
-- mainmenu.lua: Main menu scene.

scenes.mainmenu = {}

local splashes = splitNewline(love.filesystem.read("splashes.txt"))

local gui = {
	playbtn = {
		type = "button",
		x = 490, y = 10*32,
		size = { x = 300, y = 96 },
		label = S("Play"),
		on_click = function()
			switchState("selectlevel")
		end
	}
}

local current_splash = 1

function scenes.mainmenu.init()
	current_splash = math.random(1, #splashes)
end

function scenes.mainmenu.update()
	gtk.update(gui)
end

function scenes.mainmenu.draw()
	drawBG(44/255, 100/255, 141/255)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.biggest)
	printOutlined("Box Smasher", 350, 53, 6)

	love.graphics.setFont(fonts.sans.medium)
	love.graphics.setColor(1,1,0)
	drawCenteredTextRot(320, 135, 400, 200, splashes[current_splash], -math.pi/8, step)
end
