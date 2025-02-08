-- Main entrypoint file

local r = function(file)
	if type(file) == "table" then
		for _, f in ipairs(file) do
			require(f)
		end
		return
	end
	return require(file)
end

-- Third party libraries
json = r"lib.json"
bf = r"lib.breezefield.init"


r{
	-- common
	"assets",
	"colour",
	"dbg",
	"draw",
	"input",
	"level",
	"overlay",
	"scene",
	"sound",
	"text",
	"util",
	"window",

	-- savegame
	"savegame.savegame",
	"savegame.statistics",

	-- gui
	"gui.gui",
	"gui.button",
	"gui.texbutton",
}

-- scenes
scenes = {
	about = r"scenes.about",
	game = r"scenes.game",
	intro = r"scenes.intro",
	mainmenu = r"scenes.mainmenu",
	selectlevel = r"scenes.selectlevel",
	settings = r"scenes.settings",
	statistics = r"scenes.statistics"
}

-- overlays
overlays = {
	final = r"overlays.final",
	success = r"overlays.success",
	pause = r"overlays.pause"
}

VERSION = nil

-- On load callback
function love.load()
	VERSION = json.decode(love.filesystem.read("data/version.json"))

	love.graphics.setDefaultFilter('nearest', 'nearest', 4)

	savegame.load()
	savegame.setDefault('levelsUnlocked', 1)
	savegame.setDefault('seenTutorial', false)
	savegame.setDefault('fullscreen', love.system.getOS() == 'Android')
	savegame.setDefault('enableSound', true)

	love.window.setFullscreen(savegame.get('fullscreen'))

	if love.system.getOS() == "Android" then
		-- LÖVE doesn't send a resize event at startup anymore on Android 15+. It is unclear if
		-- this is how it should work, or if this is a bug in LÖVE. Let's just send a manual
		-- resize event to our code to fix it.
		love.resize(love.graphics.getWidth(), love.graphics.getHeight())
	end

	images = assets.loadImages()
	fonts = assets.loadFonts()
	sounds = assets.loadSounds()

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
	window.draw_transformation()

	-- Default font & draw colour
	love.graphics.setFont(fonts.sans.medium)
	love.graphics.setColor(1,1,1)

	scene.runDraw()
	overlay.runDraw()
	dbg.runDraw()

	scene.performTransition()
end

-- All input should use these callbacks in the future, but for now it's only used by the hardcoded Android back button
function love.keypressed(key)
	if key == "f11" then
		local newState = not savegame.get("fullscreen")
		love.window.setFullscreen(newState)
		savegame.set("fullscreen", newState)
	end

	if love.system.getOS() == "Android" and key == "escape" then
		if overlay.isActive() then
			overlay.runBack()
		else
			scene.runBack()
		end
	end
end

function love.resize(w, h)
	window.resize(w, h)
end

function love.quit()
	savegame.save()

	if love.system.getOS() == "Android" then
		-- The game is put in a zombie state on quit for some reason, causing it to not be openable
		-- again. No idea where the issue is, but just exit the old fashioned way. (Principia also
		-- needs to do this on Android to properly exit, so the issue may lie with SDL2)
		os.exit()
	end

	return false
end
