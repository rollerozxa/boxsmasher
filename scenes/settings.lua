
local settings = {
	background = { 11, 75, 122 },
	gui = Gui:new()
}

function getBooleanLabel(bool)
	return bool and S("Enabled") or S("Disabled")
end

function settings.init()
	settings.gui:add("back", Button:new{
		x = 40*1, y = 40*15,
		w = 280, h = 80,
		label = S("Back"),
		keybind = "escape",
		onClick = function()
			scene.switch("mainmenu")
		end
	})

	settings.gui:add("fullscreen", Button:new{
		x = 40*11, y = 40*4,
		w = 40*8, h = 40*2,
		label = getBooleanLabel(love.window.getFullscreen()),
		onClick = function(self)
			love.window.setFullscreen(not love.window.getFullscreen())
			self.label = getBooleanLabel(love.window.getFullscreen())
		end,
	})

	settings.gui:add("sound", Button:new{
		x = 40*11, y = 40*7,
		w = 40*8, h = 40*2,
		label = getBooleanLabel(savegame.get("enableSound")),
		onClick = function(self)
			local newState = (not savegame.get("enableSound"))
			savegame.set("enableSound", newState)
			self.label = getBooleanLabel(newState)
			sound.play("spawn")
		end
	})
end

function settings.back()
	scene.switch("mainmenu")
end

function settings.draw()
	love.graphics.setFont(fonts.sans.bigger)
	text.drawOutlined("Settings", 40, 40, 3)

	love.graphics.setFont(fonts.sans.big)
	love.graphics.print(S("Fullscreen mode:"), 40, 40*4.5)

	love.graphics.print(S("Enable sound:"), 40, 40*7.5)

end

return settings
