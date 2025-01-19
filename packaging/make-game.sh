#!/bin/bash -eu

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
source ${SRCDIR}/packaging/_common.sh

cd "$SRCDIR"
echo "Creating LÖVE package..."
zip -r "$GAME_FILE" ./* -x '*.git*' -x 'packaging/*'

cp "$GAME_FILE" "${SRCDIR}/packaging/bin/"
