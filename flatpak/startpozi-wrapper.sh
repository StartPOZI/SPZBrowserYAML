#!/bin/sh
# Flatpak launcher for StartPOZI Browser.
# zypak-wrapper (from org.electronjs.Electron2.BaseApp) handles the
# Chromium sandbox inside the Flatpak sandbox.
exec zypak-wrapper.sh /app/browser/startpozi-desktop-browser-beta "$@"
