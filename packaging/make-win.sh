#!/bin/bash -eu

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
source ${SRCDIR}/packaging/_common.sh

FOLDER="box-smasher-win64"

cd "$BUILDDIR"

wget "$LOVE_WINDOWS_URL" -O "$LOVE_WINDOWS_ZIP"
mkdir -p "$FOLDER"
bsdtar --strip-components 1 -xvf "$LOVE_WINDOWS_ZIP" -C "$FOLDER"

cd "$FOLDER"
rm changes.txt game.ico love.ico lovec.exe readme.txt

cat love.exe "$GAME_FILE" > "$GAME_EXE"
rm love.exe

VER="${VER_MAJOR}.${VER_MINOR}.${VER_PATCH}"

rcedit "$GAME_EXE" \
	--set-icon "${SRCDIR}/packaging/icon.ico" \
	--set-file-version "$VER" \
	--set-product-version "$VER" \
	--set-version-string FileDescription "Box Smasher" \
	--set-version-string FileVersion "$VER_STRING" \
	--set-version-string CompanyName "ROllerozxa" \
	--set-version-string LegalCopyright "(c) ROllerozxa, et al." \
	--set-version-string ProductName "Box Smasher" \
	--set-version-string ProductVersion "$VER_STRING" \
	--set-version-string OriginalFilename "$GAME_EXE"

cd ..
cp -r "$FOLDER" "$BINDIR"
