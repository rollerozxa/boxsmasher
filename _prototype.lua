bf = require("lib.breezefield")

local resolution = {
	--x = 720,
	--y = 1280
	x = 800,
	y = 600
}

local objects = {
	scene = {},
	water = {}
}

local joints = {

}

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

function love.graphics.arrow(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle))
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end


function rotatedRectangle(mode, x, y, width, height, angle)
	-- We cannot rotate the rectangle directly, but we
	-- can move and rotate the coordinate system.
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the top left corner
	love.graphics.pop()
end

function coolRandomColour()
	local happy = false
	local c
	while not happy do
		c = {
			r = math.clamp(math.random(0,1), 0.3, 0.9),
			g = math.clamp(math.random(0,1), 0.3, 0.9),
			b = math.clamp(math.random(0,1), 0.3, 0.9)
		}

		if (c.r == 0.3 and c.g == 0.3 and c.b == 0.3)
		or (c.r == 0.9 and c.g == 0.9 and c.b == 0.9) then
			-- all-black isn't a fun colour (I want something colourful!!!)
		else
			happy = true
		end
	end

	return c
end

function spawn_a_bunch_of_fucking_boxes()
	for x = 1, 10, 1 do
		for y = 1, 10, 1 do
			local newBox = world:newCollider("Rectangle", { 400+(x*21), 200+(y*21), 20, 20 })
			newBox:setMass(0.04)
			newBox.colour = coolRandomColour()
			function newBox:draw()
				math.randomseed(math.floor(self:getX()/1)+math.floor(self:getY()/1))
				local c = self.colour
				love.graphics.setColor(c.r, c.g, c.b)
				rotatedRectangle('fill', self:getX(), self:getY(), 20, 20, self:getAngle())
				love.graphics.setColor(0,0,0)
				rotatedRectangle('line', self:getX(), self:getY(), 20, 20, self:getAngle())
			end
		end
	end
end

function love.load()
	--love.window.setMode(resolution.x, resolution.y)

	world = bf.newWorld(0, 90.81, true)

	local static_rects = {
		{resolution.x/2, resolution.y-25, resolution.x/2, 50}
	}

	for _, static_rect in pairs(static_rects) do
		local rect = world:newCollider("Rectangle", static_rect)
		rect:setType("static")
		rect.fixture:setFriction(0.75)
		--function rect:draw()
		--	love.graphics.rectangle('fill', 0, resolution.y-50, resolution.x, 50)
		--end
	end
	objects.scene.ground = rect


end

local helddown = false

local throw = {x = 0, y = 0}

local step = 0

function love.update(dt)
	if love.keyboard.isDown('s') and not oldspawndown then
		spawn_a_bunch_of_fucking_boxes()
	end
	oldspawndown = love.keyboard.isDown('s')

	world:update(dt)

	if love.mouse.isDown(1) then

		local mx, my = love.mouse.getPosition()
		if not helddown then
			objects.box = world:newCollider("Rectangle", {mx, my, 30, 30 })
			joints.boxMouse = love.physics.newMouseJoint(objects.box.body, mx, my)
			joints.boxMouse:setTarget(love.mouse.getPosition())
		end

		helddown = true


		local ox, oy = objects.box:getPosition()

		throw.x = mx-ox
		throw.y = my-oy


	elseif helddown then
		joints.boxMouse:destroy()
		helddown = false

		objects.box:applyLinearImpulse(-throw.x*5, -throw.y*5)
	end

end

function love.draw()
	love.graphics.setBackgroundColor(0.6, 0.6, 1)
	world:draw()

	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line', 40, 250, 150, 200)

	if objects.box then
		local ox, oy = objects.box:getPosition()
		love.graphics.setColor(1,0,0)
		love.graphics.arrow(ox, oy, ox-throw.x, oy-throw.y, 10, math.pi/4)

	end
end
