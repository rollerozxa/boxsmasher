-- Main menu scene

scenes.mainmenu = {}

local splashes = splitNewline(love.filesystem.read("data/splashes.txt"))

local boxes = {}

local current_splash = 1

local playBtn = Button:new{
	x = 490, y = 10*32,
	w = 300, h = 96,
	label = S("Play"),
	keybind = "p",
	onClick = function()
		switchState("selectlevel")
	end
}

local statsBtn = Button:new{
	x = 40*8, y = 40*11,
	w = 300, h = 96,
	label = S("Statistics"),
	keybind = "s",
	onClick = function()
		switchState("statistics")
	end
}

-- Adds a new hittable box into the world, with proper draw function and
-- physics properties.
local function newBox(x,y,w,h)
	local box = world:newCollider("Rectangle", { x-(w/2),y-(h/2),w,h })
	box.colour = coolRandomColour()

	function box:draw()
		draw.box(self:getX(), self:getY(), w, h, self:getAngle(), box.colour)
	end

	table.insert(boxes, box)
end

local step = 0

scenes.mainmenu.background = { r = 44, g = 100, b = 141 }

function scenes.mainmenu.init()
	step = 0

	world = bf.newWorld(0, 90.82*2, true)
end

function scenes.mainmenu.update(dt)
	playBtn:update()
	statsBtn:update()

	world:update(dt)

	if step % 4 == 0 then
		local lolo = math.random(0, base_resolution.x)
		--local lolo = (step*10) % base_resolution.x
		newBox(lolo, -20, 40, 40)
	end

	if step % 340 == 0 then
		current_splash = math.random(1, #splashes)
	end

	for key, box in pairs(boxes) do
		local x, y = box:getPosition()
		if y > base_resolution.y + 64 then
			box:destroy()
			boxes[key] = nil
		end
	end

	step = step + 1
end

require("_version")

function scenes.mainmenu.draw()

	world:draw()

	love.graphics.setLineWidth(4)

	playBtn:draw()
	statsBtn:draw()

	love.graphics.setFont(fonts.sans.biggest)
	printOutlined("Box Smasher", 350, 53, 6)

	if string.len(splashes[current_splash]) > 20 then
		love.graphics.setFont(fonts.sans.medium)
	else
		love.graphics.setFont(fonts.sans.big)
	end
	love.graphics.setColor(1,1,0.3)
	drawCenteredTextRot(320, 135, 400, 200, splashes[current_splash], -math.pi/8, step)

	love.graphics.setColor(1,1,1)
	love.graphics.setFont(fonts.sans.small)
	drawRightText(0, base_resolution.y-50, base_resolution.x-5, "© 2023-2025 ROllerozxa")
	drawRightText(0, base_resolution.y-25, base_resolution.x-5, "Licensed under the GPLv3. Do distribute!")

	love.graphics.print("Box Smasher v" .. GAME_VERSION, 5, base_resolution.y-25)
end
