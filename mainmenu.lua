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

local boxes = {}

local current_splash = 1

-- Adds a new hittable box into the world, with proper draw function and
-- physics properties.
local function newBox(x,y,w,h)

	-- New dynamic rectangle collider, the box!
	local box = world:newCollider("Rectangle", { x-(w/2),y-(h/2),w,h })

	-- Give the box a random colour, save it to the box object's userdata so
	-- it can be accessed in the draw method.
	box.colour = coolRandomColour()

	-- Redefine the box object's draw method, draw a filled box with the colour
	-- stored in userdata (the colour method variable)
	function box:draw()
		love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
		rotatedRectangle('fill', self:getX(), self:getY(), w, h, self:getAngle())
		love.graphics.setColor(0,0,0)
		rotatedRectangle('line', self:getX(), self:getY(), w, h, self:getAngle())
	end

	-- Add the box object to the boxes table (actually a reference) so it can be iterated over.
	table.insert(boxes, box)
end

local step = 0

scenes.mainmenu.background = { r = 44, g = 100, b = 141 }

function scenes.mainmenu.init()
	step = 0

	world = bf.newWorld(0, 90.82*2, true)
end

function scenes.mainmenu.update(dt)
	gtk.update(gui)

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

function scenes.mainmenu.draw()

	world:draw()

	love.graphics.setLineWidth(4)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.biggest)
	printOutlined("Box Smasher", 350, 53, 6)

	if string.len(splashes[current_splash]) > 20 then
		love.graphics.setFont(fonts.sans.medium)
	else
		love.graphics.setFont(fonts.sans.big)
	end
	love.graphics.setColor(1,1,0.3)
	drawCenteredTextRot(320, 135, 400, 200, splashes[current_splash], -math.pi/8, step)
end
