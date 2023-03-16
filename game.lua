
scenes.game = {}

-- Sample level for testing.
local lvl = {
	throwBoundary = {
		x = 100, y = 200,
		w = 100, h = 300,
	},
	boxclusters = {
		{
			x = 200, y = 100,
			w = 20, h = 20,
			aX = 5, aY = 5
		},
	},
	terrain = {
		{
			x = 200, y = 200,
			w = 100, h = 50
		}, {
			x = 620, y = 600,
			w = 250, h = 150
		}
	}
}

-- Variables to store references of various physics objects.
local objects = { scene = {} }
local joints = {}

-- Adds a new hittable box into the world, with proper draw function and
-- physics properties.
local function newBox(x,y,w,h)

	-- New dynamic rectangle collider, the box!
	local newBox = world:newCollider("Rectangle", { x,y,w,h })
	newBox:setMass(0.04)

	-- Give the box a random colour, save it to the box object's userdata so
	-- it can be accessed in the draw method.
	newBox.colour = coolRandomColour()

	-- Redefine the box object's draw method, draw a filled box with the colour
	-- stored in userdata (the colour method variable)
	function newBox:draw()
		love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
		rotatedRectangle('fill', self:getX(), self:getY(), 20, 20, self:getAngle())
		love.graphics.setColor(0,0,0)
		rotatedRectangle('line', self:getX(), self:getY(), 20, 20, self:getAngle())
	end
end

-- Keep track of left mouse button state
local helddown = false

-- Throw vector
local throw = {x = 0, y = 0}

function scenes.game.init()
	-- Hello (physics) world.
	world = bf.newWorld(0, 90.81, true)

	for _, ter in pairs(lvl.terrain) do
		-- Box2D works with the center of mass (for rectangles they're in the middle of the rectangle),
		-- but level definition works with rectangles with origin being top left. We need to convert these.
		local dim = {
			ter.x-(ter.w/2),
			ter.y-(ter.h/2),
			ter.w, ter.h}

		-- Make a static collider with the dimensions of the terrain object
		local rect = world:newCollider("Rectangle", dim)
		rect:setType("static")
		rect.fixture:setFriction(0.6)

		table.insert(objects.scene, rect)
	end

	-- TEMPx86
	for x = 1, 10, 1 do
		for y = 1, 10, 1 do
			newBox(400+(x*21), 200+(y*21), 20, 20)
		end
	end
end

function scenes.game.update(dt)
	-- Iterate physics.
	world:update(dt)

	-- Box throwing code. When holding down mouse...
	if love.mouse.isDown(1) then

		-- Get mouse position, convert it from the scaled screen resolution
		-- to internal coordinates.
		local mx, my = unscaled(love.mouse.getPosition())

		-- Just started holding the mouse? Create a box at the mouse's position,
		-- add a mouse joint to keep it static until thrown.
		if not helddown then
			objects.box = world:newCollider("Rectangle", {mx, my, 30, 30})
			joints.boxMouse = love.physics.newMouseJoint(objects.box.body, mx, my)
			joints.boxMouse:setTarget(mx, my)
		end

		-- Now we're holding it down...
		helddown = true

		-- Calculate "throw vector", like a slingshot. It is inverse of the vector
		-- that is the difference in coordinates between the created box and mouse.
		local ox, oy = objects.box:getPosition()
		throw.x = -(mx-ox)
		throw.y = -(my-oy)

	-- When helddown is true, but mouse is not held (i.e. mouse has been released, we're throwing it!)
	elseif helddown then
		-- Destroy mouse joint, don't make it static anymore.
		joints.boxMouse:destroy()
		helddown = false

		-- Apply a linear impulse with the throw vector that makes the box go wheee
		-- (hopefully crashing into some boxes ^^)
		objects.box:applyLinearImpulse(throw.x*5, throw.y*5)
	end
end

function scenes.game.draw()
	drawBG(0.6, 0.6, 1)

	-- Draw physics objects using Breezefield.
	world:draw()

	-- Draw the throw boundary
	love.graphics.setColor(1,1,1)
	local bndry = lvl.throwBoundary
	love.graphics.rectangle('line', bndry.x, bndry.y, bndry.w, bndry.h)

	if objects.box then
		local ox, oy = objects.box:getPosition()
		love.graphics.setColor(1,0,0)
		love.graphics.arrow(ox, oy, ox+throw.x, oy+throw.y, 10, math.pi/4)
	end
end
