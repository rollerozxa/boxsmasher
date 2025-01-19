#!/bin/bash -e

BUILDDIR="/tmp/box"
BINDIR="${SRCDIR}/packaging/bin"

LOVE_VERSION="11.5"
LOVE_DL_URL="https://github.com/love2d/love/releases/download"
LOVE_WINDOWS_ZIP="love-${LOVE_VERSION}-win64.zip"
LOVE_WINDOWS_URL="${LOVE_DL_URL}/${LOVE_VERSION}/${LOVE_WINDOWS_ZIP}"
LOVE_LINUX_APPIMAGE="love-${LOVE_VERSION}-x86_64.AppImage"
LOVE_LINUX_URL="${LOVE_DL_URL}/${LOVE_VERSION}/${LOVE_LINUX_APPIMAGE}"

GAME_FILE="${BUILDDIR}/box-smasher.love"
GAME_EXE="box_smasher.exe"

VERSION_FILE="${SRCDIR}/data/version.json"
VER_MAJOR=$(jq -r '.version.major' "$VERSION_FILE")
VER_MINOR=$(jq -r '.version.minor' "$VERSION_FILE")
VER_PATCH=$(jq -r '.version.patch' "$VERSION_FILE")
VER_STRING=$(jq -r '.string' "$VERSION_FILE")
VER_DEV=$(jq -r '.is_dev' "$VERSION_FILE")

mkdir -p "$BUILDDIR"
mkdir -p "$BINDIR"
