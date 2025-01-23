-- about.lua: about dialog

scenes.about = {}

local backBtn = Button:new{
	x = 40*1, y = 40*15,
	w = 280, h = 80,
	label = S("Back"),
	keybind = "escape",
	onClick = function()
		scene.switch("mainmenu")
	end,
	isOverlay = true
}

local websiteBtn = Button:new{
	x = 40*14, y = 40*15,
	w = 650, h = 80,
	label = S("Visit boxsmasher.voxelmanip.se"),
	onClick = function()
		love.system.openURL("https://boxsmasher.voxelmanip.se")
	end,
	isOverlay = true
}

local abouttext

scenes.about.background = { 11, 75, 122 }

function scenes.about.init()
	abouttext = love.filesystem.read("data/about.txt") or ""
end

function scenes.about.back()
	scene.switch("mainmenu")
end

function scenes.about.update()
	backBtn:update()
	websiteBtn:update()
end

function scenes.about.draw()
	love.graphics.setFont(fonts.sans.bigger)
	printOutlined("Box Smasher", 40, 40, 3)

	love.graphics.setFont(fonts.sans.big)
	love.graphics.print(abouttext, 40, 120)

	backBtn:draw()
	websiteBtn:draw()
end
