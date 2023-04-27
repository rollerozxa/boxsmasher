# Untitled Physics Game (LÖVE)
School project haha

It's like angry birds, but you throw boxes as other stacks of boxes, off the screen.

## Running
Obtain LÖVE. Run, within this directory:

`love .`

Dragging the folder over the LÖVE runtime works too.

## Prototype
There is a prototype in _prototype.lua. Rename it to main.lua and run...

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
