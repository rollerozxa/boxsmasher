#!/bin/bash -eu

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
source ${SRCDIR}/packaging/_common.sh

cd "$BINDIR"

butler push box-smasher-win64 rollerozxa/box-smasher:windows_x64 --userversion "$VER_STRING"
butler push Box_Smasher-x86_64.AppImage rollerozxa/box-smasher:linux_x64 --userversion "$VER_STRING"
butler push box-smasher.love rollerozxa/box-smasher:love_universal --userversion "$VER_STRING"
