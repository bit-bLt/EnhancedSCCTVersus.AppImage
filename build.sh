#!/bin/sh

APPIMAGE_TOOL_URI="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
APPIMAGE_TOOL="appimagetool-x86_64.AppImage"
PACKAGE_NAME="Enhanced_SCCT_Versus.AppImage"
APP_DIR="EnhancedSCCTVersus.AppDir"

# Download and install external data
if [ "$1" = "--ext" ]; then
    echo "Installing External data..."
    . ./ext.sh
fi

if [ ! -f "${APPIMAGE_TOOL}" ]; then
    echo "Downloading appimagetool..."
    wget "${APPIMAGE_TOOL_URI}" -q --show-progress
fi

chmod +x "${APPIMAGE_TOOL}"

echo "Building AppImage..."
ARCH=x86_64 ./"${APPIMAGE_TOOL}" "${APP_DIR}" "${PACKAGE_NAME}"

echo "Build finished!"
