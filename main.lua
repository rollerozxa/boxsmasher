-- Main entrypoint file

game = {
	-- The current level, if a level has been opened.
	level = 1,
	-- How many levels have been unlocked, loaded from savegame.
	levelsUnlocked = 1,
	-- The current scene that should be shown.
	state = "mainmenu",
	-- The current overlay that should be shown, if applicable.
	overlay = false,

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

scenes = {}
overlays = {}

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
r"draw"
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

dbg = r"dbg"

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
	print(totalLevels)

	savegame.load()
	game.levelsUnlocked = savegame.get('levelsUnlocked') or 1
	game.seenTutorial = savegame.get('seenTutorial') or false

	math.randomseed(os.time())

	-- Hardcode initial state init
	if scenes[game.state].init ~= nil then
		scenes[game.state].init()
	end
end

function love.update(dt)

	if scenes[game.state].update ~= nil then
		scenes[game.state].update(dt)
	end

	if game.overlay then
		if overlays[game.overlay].update ~= nil then
			overlays[game.overlay].update()
		end
	end

	oldmousedown = love.mouse.isDown(1)

	-- Check for quit keybind (ctrl+q, hardcoded in Android too I think)
	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('q') then
		love.event.quit()
	end

	-- Debug options (accessible with F3+<arbitrary>, see dbg.lua)
	if love.keyboard.isDown('f3') then
		for id, def in pairs(dbg) do
			if love.keyboard.isDown(def.keybind) and not sparsifier[def.keybind] then
				dbg[id].enabled = not dbg[id].enabled
			end
			sparsifier[def.keybind] = love.keyboard.isDown(def.keybind)
		end
	end

	savegame.runSaveTimer(dt)
end

local trans_alpha = 0

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

	-- Call scene's draw function
	local bg
	if scenes[game.state].draw ~= nil then
		if scenes[game.state].background then
			bg = scenes[game.state].background

			drawBG(love.math.colorFromBytes(bg.r, bg.g, bg.b))
		end

		scenes[game.state].draw()
	end

	if game.overlay then
		if overlays[game.overlay].draw ~= nil then
			overlays[game.overlay].draw()
		end
	end

	if scenes[game.state].background then
		drawBGLetterbox(love.math.colorFromBytes(bg.r, bg.g, bg.b))
	end

	-- Call debug functionalities' draw functions
	-- (if they're enabled)
	for id, def in pairs(dbg) do
		if def.enabled then
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(fonts.sans.medium)
			def.draw()
		end
	end

	if game.trans then
		if game.trans_step < 25 then
			trans_alpha = trans_alpha + 10
		else
			trans_alpha = trans_alpha - 10
		end

		love.graphics.setColor(0,0,0,trans_alpha/255)

		love.graphics.push()
		love.graphics.origin()

		love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		love.graphics.pop()

		game.trans_step = game.trans_step + 1

		if game.trans_step == 25 then
			game.state = game.trans_to

			if scenes[game.state].init ~= nil then
				scenes[game.state].init()
			end
		elseif game.trans_step == 50 then
			game.trans = false
		end
	end
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
