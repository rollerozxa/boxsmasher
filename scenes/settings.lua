
local settings = {
	background = { 11, 75, 122 },
	gui = Gui:new()
}

function settings.init()
	settings.gui:add("back", Button:new{
		x = 40*1, y = 40*15,
		w = 280, h = 80,
		label = S("Back"),
		keybind = "escape",
		onClick = function()
			scene.switch("mainmenu")
		end,
		isOverlay = true
	})
end

function settings.back()
	scene.switch("mainmenu")
end

function settings.draw()
	love.graphics.setFont(fonts.sans.bigger)
	printOutlined("Settings", 40, 40, 3)
end

return settings
