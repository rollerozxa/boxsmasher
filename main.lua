
-- main.lua: Main script, take care of scenes and initialisations.

game = {
	level = 1,
	levelsUnlocked = 1,
	state = "mainmenu",
	overlay = false
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

-- Scene and overlay table
-- (Stores all scenes and overlays)
scenes = {}
overlays = {}

oldmousedown = false

-- Keeps track of held down keys to prevent repeating actions.
-- (Principia reference, hehe: https://principia-web.se/wiki/Sparsifier)
sparsifier = {}

-- Dummy translation function
-- (Future proofing for when a translation system is implemented)
function S(text, ...)
	return string.format(text, ...)
end

require("fonts")
require("util")
require("gtk")
require("savegame")

require("mainmenu")
require("game")
require("selectlevel")

require("success")
require("pause")

-- debug stuffs
avlusn = require("avlusn")

-- Load the Breezefield library into 'bf'
bf = require("lib.breezefield")
-- Load the JSON library into 'json'
json = require("lib.json")

-- On load callback
function love.load()
	-- resizable = true makes Android landscape.
	love.window.setMode(resolution.x, resolution.y, { resizable = true })
	love.window.setTitle("teehee")
	love.graphics.setDefaultFilter('nearest', 'nearest', 4)

	-- Hide navigation bar and notification tray
	if love.system.getOS() == 'Android' then
		love.window.setFullscreen(true)
	end

	assets = {
		back_btn = newImage("back_btn"),
		lvlok = newImage("lvlok"),
		lock = newImage("lock"),
		menu = newImage("menu"),
	}

	-- Load fonts into table variable
	fonts = initFonts()

	sounds = {
		click = newSound("click"),
		pop = newSound("pop"),
		success = newSound("success")
	}

	savegame.load()

	-- Hardcode initial state init
	if scenes[game.state].init ~= nil then
		scenes[game.state].init()
	end
end

-- On update callback
function love.update(dt)
	-- Call scene's update function
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

	-- Debug options (accessible with F3+<arbitrary>, see avlusn.lua)
	if love.keyboard.isDown('f3') then
		-- Iterate over each debug entry, toggle the activation of the given debug functionality
		-- if keybind is triggered.
		for id, def in pairs(avlusn) do
			if love.keyboard.isDown(def.keybind) and not sparsifier[def.keybind] then
				avlusn[id].enabled = not avlusn[id].enabled
			end
			sparsifier[def.keybind] = love.keyboard.isDown(def.keybind)
		end
	end
end

-- On draw callback
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
	if scenes[game.state].draw ~= nil then
		scenes[game.state].draw()
	end

	if game.overlay then
		if overlays[game.overlay].draw ~= nil then
			overlays[game.overlay].draw()
		end
	end

	-- Call debug functionalities' draw functions
	-- (if they're enabled)
	for id, def in pairs(avlusn) do
		if def.enabled then
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(fonts.sans.medium)
			def.draw()
		end
	end
end

-- Callback for when window resizes
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
