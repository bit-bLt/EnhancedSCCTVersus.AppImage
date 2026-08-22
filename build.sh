#!/bin/sh

APP_IMAGE_TOOL_URI="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"

PACKAGE_NAME="Enhanced_SCCT_Versus.AppImage"

[ ! -f "appimagetool-x86_64.AppImage" ] && wget "${APP_IMAGE_TOOL_URI}"

chmod +x appimagetool-x86_64.AppImage

./appimagetool-x86_64.AppImage EnhancedSCCTVersus.AppDir "${PACKAGE_NAME}"
