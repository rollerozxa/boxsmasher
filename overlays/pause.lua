-- Pause overlay

local pause = {
	gui = Gui:new()
}

function pause.init()
	pause.gui:add("resume", Button:new{
		x = 480, y = 40*5,
		w = 40*8, h = 96,
		label = S("Resume"),
		keybind = "escape",
		onClick = function()
			overlay.switch(false)
		end,
		isOverlay = true
	})

	pause.gui:add("restart", Button:new{
		x = 480, y = 40*9,
		w = 40*8, h = 96,
		label = S("Restart"),
		onClick = function()
			overlay.switch(false)
			scene.restart()
		end,
		isOverlay = true
	})

	pause.gui:add("exit", Button:new{
		x = 480, y = 40*13,
		w = 40*8, h = 96,
		label = S("Exit"),
		onClick = function()
			overlay.switch(false)
			scene.switch('selectlevel')
		end,
		isOverlay = true
	})
end

function pause.back()
	overlay.switch(false)
end

function pause.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	drawCenteredText(4, 64, base_resolution.x, 64, S("Game paused"))
end

return pause
