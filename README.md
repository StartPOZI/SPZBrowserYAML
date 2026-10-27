# Упаковка (Flatpak / Snap)

YAML-исходники упаковки браузера:

```
packaging/flatpak/
  com.startpozi.browser.desktop.yml          # манифест flatpak-builder
  com.startpozi.browser.desktop.desktop      # .desktop-файл
  com.startpozi.browser.desktop.metainfo.xml # метаданные AppStream
  startpozi-wrapper.sh                       # запуск через zypak
snap/
  snapcraft.yaml                             # манифест snapcraft (канонический путь)
  wrapper                                    # обёртка запуска (PATH до tor и т.д.)
  startpozi-browser.desktop                  # .desktop-файл
```

Оба манифеста собирают приложение сами (`npm ci` → `electron-builder --linux dir`)
и кладут рядом Tor и pluggable-транспорты (obfs4 / snowflake / webtunnel),
которые браузер ищет через PATH (`which tor`, см. `main.js`).

## Flatpak

Требуется один раз:

```bash
flatpak install flathub \
  org.freedesktop.Sdk//24.08 org.freedesktop.Platform//24.08 \
  org.electronjs.Electron2.BaseApp//24.08 \
  org.freedesktop.Sdk.Extension.golang//24.08 \
  org.freedesktop.Sdk.Extension.node20//24.08
```

Сборка (из корня репозитория):

```bash
flatpak-builder --user --install --force-clean \
  .flatpak-build packaging/flatpak/com.startpozi.browser.desktop.yml

flatpak run com.startpozi.browser.desktop
```

Tor/tor-транспорты ставятся в `/app/bin`, Chromium-песочница обрабатывается
через zypak из Electron BaseApp.

## Snap

```bash
snapcraft --use-lxd            # или: snapcraft --use-container
sudo snap install --dangerous startpozi-browser_1.0.0_amd64.snap
snap run startpozi-browser
```

- `tor` и `obfs4proxy` берутся из архива Ubuntu (stage-packages),
  `snowflake-client` и `webtunnel-client` собираются из исходников Go.
- `browser-support` с `allow-sandbox: true` сохраняет SUID `chrome-sandbox`;
  при публикации в Snap Store этот plug проходит ревью.

## Заметки

- `StartupWMClass=startpozi-desktop-browser-beta` соответствует имени
  исполняемого файла electron-builder. Чтобы WM_CLASS совпадал с id
  desktop-файла, можно задать `desktopName` в секции `build.linux`
  package.json (см. предупреждение electron-builder при сборке).
- Версии Tor/транспортов зафиксированы тегами/коммитами при публикации
  (в манифестах Flatpak-источники `git` без пина — закрепите commit
  для воспроизводимых сборок).
# SPZBrowserYAML
