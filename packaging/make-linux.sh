#!/bin/bash -eu

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
source ${SRCDIR}/packaging/_common.sh

if [ ! -f /tmp/appimagetool ]; then
	wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /tmp/appimagetool
	chmod +x /tmp/appimagetool
fi

cd "$BUILDDIR"

rm -rf squashfs-root

wget "$LOVE_LINUX_URL" -O "$LOVE_LINUX_APPIMAGE"
chmod +x "$LOVE_LINUX_APPIMAGE"
./${LOVE_LINUX_APPIMAGE} --appimage-extract

cd squashfs-root

rm -rf share/
rm AppRun love.desktop love.svg

cp "${SRCDIR}/packaging/AppRun" .
cp "${SRCDIR}/packaging/box-smasher.desktop" .
cp "${SRCDIR}/data/icon.png" box-smasher.png
ln -sf box-smasher.png .DirIcon

cp "$GAME_FILE" .

cd ..

ARCH=x86_64 /tmp/appimagetool --appimage-extract-and-run squashfs-root/
