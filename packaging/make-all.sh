#!/bin/bash

cd $(dirname "$BASH_SOURCE[0]")
./make-game.sh
./make-win.sh
./make-linux.sh
