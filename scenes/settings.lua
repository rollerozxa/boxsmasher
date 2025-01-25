
scenes.settings = {
	background = { 11, 75, 122 }
}
local gui

function scenes.settings.init()
	gui = Gui:new()

	gui:add("back", Button:new{
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

function scenes.settings.back()
	scene.switch("mainmenu")
end

function scenes.settings.update()
	gui:update()
end

function scenes.settings.draw()
	love.graphics.setFont(fonts.sans.bigger)
	printOutlined("Settings", 40, 40, 3)

	gui:draw()
end
