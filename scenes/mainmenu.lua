-- Main menu scene

local mainmenu = {
	background = { 44, 100, 141 },
	gui = Gui:new()
}

local splashes, current_splash, step

local boxes = {}

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

function mainmenu.init()
	mainmenu.gui:add("play", Button:new{
		x = 490, y = 10*32,
		w = 300, h = 96,
		label = S("Play"),
		keybind = "p",
		onClick = function()
			scene.switch("selectlevel")
		end
	})

	mainmenu.gui:add("statistics", Button:new{
		x = 40*8, y = 40*11,
		w = 300, h = 96,
		label = S("Statistics"),
		keybind = "s",
		onClick = function()
			scene.switch("statistics")
		end
	})

	mainmenu.gui:add("about", Button:new{
		x = 40*17-20, y = 40*11,
		w = 300, h = 96,
		label = S("About"),
		keybind = "a",
		onClick = function()
			scene.switch("about")
		end
	})

	mainmenu.gui:add("settings", Button:new{
		x = base_resolution.x-80, y = 8,
		w = 72, h = 72,
		image = {
			name = "settings",
			w = 52, h = 52
		},
		onClick = function()
			scene.switch("settings")
		end,
	})

	splashes = splitNewline(love.filesystem.read("data/splashes.txt") or "missingno")
	current_splash = 1
	step = 0

	world = bf.World:new(0, 90.82*2, true)
end

function mainmenu.back()
	love.event.quit()
end

function mainmenu.update(dt)
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

function mainmenu.draw()
	world:draw()

	love.graphics.setLineWidth(4)

	love.graphics.setFont(fonts.sans.biggest)
	printOutlined("Box Smasher", 350, 53, 6)

	if splashes[current_splash]:len() > 30 then
		love.graphics.setFont(fonts.sans.small)
	elseif splashes[current_splash]:len() > 20 then
		love.graphics.setFont(fonts.sans.medium)
	else
		love.graphics.setFont(fonts.sans.big)
	end
	love.graphics.setColor(1,1,0.3)
	drawCenteredTextRot(320, 135, 400, 200, splashes[current_splash], -math.pi/8)

	love.graphics.setColor(1,1,1)
	love.graphics.setFont(fonts.sans.small)
	drawRightText(0, base_resolution.y-50, base_resolution.x-5, "© 2023-2025 ROllerozxa")
	drawRightText(0, base_resolution.y-25, base_resolution.x-5, "Licensed under the GPLv3. Do distribute!")

	love.graphics.print("Box Smasher v" .. VERSION.string, 5, base_resolution.y-25)
end

return mainmenu
