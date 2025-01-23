-- Main entrypoint file

game = {
	-- The current level, if a level has been opened.
	level = 1,
	-- How many levels have been unlocked, loaded from savegame.
	levelsUnlocked = 1,

	-- The amount of balls left. Stored globally to be accessible from level success and such.
	ballsLeft = 0
}

-- Base internal resolution ("canvas" resolution)
base_resolution = {
	x = 1280,
	y = 720
}

-- Resolution that the window is resized to (scaled up from base_resolution)
resolution = {
	x = base_resolution.x,
	y = base_resolution.y
}

-- Canvas offset, if aspect ratio is different
offset = {
	x = 0,
	y = 0
}

oldmousedown = false

-- Keeps track of held down keys to prevent repeating actions.
sparsifier = {}

-- Dummy translation function
-- (Future proofing for when a translation system is implemented)
function S(text, ...)
	return string.format(text, ...)
end

local r = function(file)
	return require(file)
end

-- common
r"assets"
r"dbg"
r"draw"
r"overlay"
r"scene"
r"util"

-- savegame
r"savegame/savegame"
r"savegame/statistics"

-- gui
r"gui/button"
r"gui/texbutton"

-- scenes
r"scenes/about"
r"scenes/game"
r"scenes/mainmenu"
r"scenes/selectlevel"
r"scenes/statistics"

-- overlays
r"overlays/final"
r"overlays/success"
r"overlays/pause"

bf = r"lib.breezefield"
json = r"lib.json"

VERSION = json.decode(love.filesystem.read("data/version.json"))

-- On load callback
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 4)

	-- Hide navigation bar and notification tray
	if love.system.getOS() == 'Android' then
		love.window.setFullscreen(true)
	end

	images = assets.loadImages()
	fonts = assets.loadFonts()
	sounds = assets.loadSounds()

	local totalLevels = 0
	while true do
		if love.filesystem.getInfo("levels/"..(totalLevels+1)..".lua") then
			totalLevels = totalLevels + 1
		else
			break
		end
	end
	game.totalLevels = totalLevels

	savegame.load()
	game.levelsUnlocked = savegame.get('levelsUnlocked') or 1
	game.seenTutorial = savegame.get('seenTutorial') or false

	math.randomseed(os.time())

	-- Hardcode initial state init
	scene.runInit()
end

function love.update(dt)
	scene.runUpdate(dt)
	overlay.runUpdate(dt)
	dbg.runUpdate()

	oldmousedown = love.mouse.isDown(1)

	-- Check for quit keybind (ctrl+q, hardcoded in Android too I think)
	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit()
	end

	savegame.runSaveTimer(dt)
end

function love.draw()
	-- Offset canvas using 'offset', scale up canvas
	-- using a factor of res / base_res
	love.graphics.translate(offset.x, offset.y)
	love.graphics.scale(
		resolution.x / base_resolution.x,
		resolution.y / base_resolution.y)

	-- Default font & draw colour
	love.graphics.setFont(fonts.sans.medium)
	love.graphics.setColor(1,1,1)

	scene.runDraw()
	overlay.runDraw()
	dbg.runDraw()

	scene.performTransition()
end

function love.resize(w, h)
	resolution.x = w
	resolution.y = h

	-- Keep aspect ratio of canvas, don't stretch it if aspect ratio is changed
	if resolution.y / resolution.x > (base_resolution.y/base_resolution.x) then
		resolution.y = math.ceil(resolution.x * (base_resolution.y/base_resolution.x))
	else
		resolution.x = math.ceil(resolution.y * (base_resolution.x/base_resolution.y))
	end

	-- Calculate offset (canvas should be in the middle, fill the edges with void)
	offset.x = (w - resolution.x) / 2
	offset.y = (h - resolution.y) / 2
end

function love.quit()
	savegame.save()

	return false
end
