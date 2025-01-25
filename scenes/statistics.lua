-- Statistics dialog

scenes.statistics = {
	background = { 11, 75, 122 }
}
local gui

function scenes.statistics.init()
	gui = Gui:new()

	gui:add("back", Button:new{
		x = 40, y = 40*14,
		w = 40*12, h = 96,
		label = S("Back to main menu"),
		keybind = "escape",
		onClick = function()
			scene.switch("mainmenu")
		end
	})
end

function scenes.statistics.back()
	scene.switch("mainmenu")
end

function scenes.statistics.update()
	gui:update()
end

angle = 0
local coolColours = {coolRandomColour(), coolRandomColour()}

local rows = {
	{
		label = "Boxes:",
		getValue = function()
			return statistics.get("boxes")
		end,
		onDraw = function(x, y)
			draw.box(x-65, y+17, 40, 40, angle, coolColours[1])
		end
	}, {
		label = "Balls thrown:",
		getValue = function()
			return statistics.get("balls")
		end,
		onDraw = function(x, y)
			draw.ball(x-65, y+17, angle, coolColours[2])
		end
	}, {
		label = "Levels unlocked:",
		getValue = function()
			return savegame.get("levelsUnlocked")
		end,
		onDraw = function(x, y)
			love.graphics.draw(images.lock, x-65, y+17, angle, 0.5, 0.5, 64, 64)
		end
	}, {
		label = "Levels played:",
		getValue = function()
			return statistics.get("levels")
		end,
		onDraw = function()
		end
	}
}

function scenes.statistics.draw()
	love.graphics.setFont(fonts.sans.bigger)
	printOutlined("Statistics", 40, 40, 3)

	love.graphics.setFont(fonts.sans.big)
	for i, row in ipairs(rows) do
		local offset = 150
		local labelwidth = 450

		love.graphics.setColor(love.math.colorFromBytes(9, 54, 87))
		love.graphics.rectangle("fill", 40, 30+i*100, 1000, 75)

		love.graphics.setColor(1,1,1)
		love.graphics.print(row.label, offset, 50+i*100)
		love.graphics.print(row.getValue(), offset+labelwidth, 50+i*100)

		if row.onDraw then
			row.onDraw(offset, 50+i*100)
		end
	end

	angle = angle + math.pi/128

	gui:draw()
end
