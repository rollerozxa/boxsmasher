<img src="https://voxelmanip.se/media/projects/boxsmasher.webp" height=360>

A fun physics-based puzzle game where you throw balls at boxes to smash them out of the screen.

<a href="https://play.google.com/store/apps/details?id=se.voxelmanip.boxsmasher"><img src="https://voxelmanip.se/assets/en_badge_web_generic.png" height=96></a>

---

## Running from source
[Obtain the LÖVE runtime for your platform](https://love2d.org/). Then within a terminal run, within this directory:

`<path to LÖVE executable> .`

Dragging the folder over the LÖVE runtime works too. For more information see the [LÖVE Wiki](https://love2d.org/wiki/Getting_Started) on how to run.

## Prototype
There is a prototype in `_prototype.lua`. Rename it to main.lua and run...

## Stuff used
- LÖVE game framework
	- Box2D physics library as part of LÖVE's physics module
- breezefield (wrapper around LÖVE's physics module)
- json.lua (Lua JSON (de)serialisation library)

## Notes

zipping up into a .love:

```bash
zip -r "game.love" ./* -x '*.git*' -x 'branding/*' -x '*.svg' -x '*.zip' -x '*.love' -x 'pseudokod.txt'
```

Sending this to an Android phone connected via ADB:

```bash
adb push game.love /sdcard/game.love && adb shell am start -S -n "org.love2d.android/.GameActivity" -d "file:///sdcard/game.love"
```
