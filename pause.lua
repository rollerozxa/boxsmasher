
-- pause.lua: Pause menu overlay

overlays.pause = {}

local gui = {
	resumebtn = {
		type = "button",
		x = 480, y = 5*40,
		size = { x = 8*40, y = 96 },
		label = S("Resume"),
		on_click = function()
			switchOverlay(false)
		end,
		keybind = 'escape'
	},

	restartbtn = {
		type = "button",
		x = 480, y = 9*40,
		size = { x = 8*40, y = 96 },
		label = S("Restart"),
		on_click = function()
			switchOverlay(false)
			scenes.game.init()
		end
	},

	exitbtn = {
		type = "button",
		x = 480, y = 13*40,
		size = { x = 8*40, y = 96 },
		label = S("Exit"),
		on_click = function()
			switchOverlay(false)
			switchState('selectlevel')
		end
	}
}

function overlays.pause.update()
	--gui = dofile('gui.lua')

	gtk.update(gui, true)
end

function overlays.pause.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	drawCenteredText(4, 64, resolution.x, 64, S("Game paused"))

	gtk.draw(gui, true)
end
