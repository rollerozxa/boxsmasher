
-- mainmenu.lua: Main menu scene.

scenes.mainmenu = {}

local gui = {
	playbtn = {
		type = "button",
		x = 490, y = 8*32,
		size = { x = 300, y = 96 },
		label = S("Play"),
		on_click = function()
			switchState("selectlevel")
		end
	}
}

function scenes.mainmenu.update()
	gtk.update(gui)
end

function scenes.mainmenu.draw()
	drawBG(64/255, 120/255, 161/255)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.biggest)
	printOutlined("Box Boom!", 410, 53, 6)
end
