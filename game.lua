-- game.lua: Main game scene.

scenes.game = {}

local gui = {
	menu = {
		type = "tex_button",
		x = base_resolution.x-(96), y = 0,
		size = { x = 96, y = 110 },
		texture = "menu",
		scale = 2.5,
		on_click = function()
			switchOverlay('pause')
		end,
		keybind = 'escape'
	},
	restart_btn = {
		type = "button",
		x = 40*23, y = 0,
		size = { x = 40*5.5, y = 40*1.8 },
		label = S("Restart"),
		on_click = function()
			scenes.game.init()
		end,
		is_visible = function()
			return game.ballsLeft == 0
		end
	}
}

local lvl

-- Table to store static terrain geometry objects
local terrain = {}
-- Store physics objects of boxes in levels
local boxes = {}
-- Store the current ball's physics object for reference
local ball = nil
-- Amount of boxes in level (decrements when they fall off the level)
local boxNum = 0
-- Total boxes in the level on start
local totalBoxes = 0

-- Misc. joint table (mouse joints and whatnot)
local joints = {}

-- Adds a new hittable box into the world, with proper draw function and
-- physics properties.
local function newBox(x,y,w,h)

	-- New dynamic rectangle collider, the box!
	local box = world:newCollider("Rectangle", { x-(w/2),y-(h/2),w,h })
	box:setMass(box:getMass()*0.25)

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

		if dbg.box_pos.enabled then
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(fonts.sans.tiny)
			love.graphics.print('{'..math.floor(self:getX())..','..math.floor(self:getY())..'}', self:getX(), self:getY())
		end
	end

	-- Add the box object to the boxes table (actually a reference) so it can be iterated over.
	table.insert(boxes, box)

	-- One more box in the level!
	boxNum = boxNum + 1
end

-- Keep track of left mouse button state
local helddown = false

local grabbedBall = false

-- Random colour for box HUD
local randc

-- Throw vector
local throw = {x = 0, y = 0}

scenes.game.background = { r = 43, g = 64, b = 43 }

function scenes.game.init()
	world = bf.newWorld(0, 90.82*1.5, true)

	-- Reset variables
	terrain = {}
	boxes = {}
	ball = nil
	boxNum = 0
	totalBoxes = 0
	joints = {}
	helddown = false
	grabbedBall = false

	randc = coolRandomColour()

	-- Load level
	--lvl = require('levels.'..game.level)
	lvl = dofile("levels/"..game.level..".lua")

	game.ballsLeft = lvl.ballsLeft or 99

	-- Iterate over terrain objects and create static colliders for them
	for _, ter in pairs(lvl.terrain) do
		-- Box2D works with the center of mass (for rectangles they're in the middle of the rectangle),
		-- but level definition works with rectangles with origin being top left. We need to convert these.
		local dim = {
			ter.x+(ter.w/2),
			ter.y+(ter.h/2),
			ter.w, ter.h}

		-- Make a static collider with the dimensions of the terrain object
		local rect = world:newCollider("Rectangle", dim)
		rect:setType("static")

		rect.colour = ter.colour or { 125/256, 227/256, 102/256 }
		local friction = ter.friction or 0.5
		local restitution = ter.restitution or 0.33

		rect.fixture:setFriction(friction)
		rect.fixture:setRestitution(restitution)

		function rect:draw()
			-- no-op
		end

		table.insert(terrain, rect)
	end

	-- Iterate over box clusters and create the boxes within them
	for _, clust in ipairs(lvl.boxclusters) do
		for x = 1, clust.aX, 1 do
			for y = 1, clust.aY, 1 do
				newBox(clust.x + (x * clust.w), clust.y + (y * clust.h), clust.w, clust.h)
			end
		end
	end

	totalBoxes = boxNum
end

function scenes.game.update(dt)
	gtk.update(gui)

	if game.overlay or game.trans then return end

	if not dbg.phys_pause.enabled then
		world:update(dt)
	end

	-- Ball throwing code. When holding down mouse...
	if love.mouse.isDown(1) and game.ballsLeft > 0 then
		-- Get mouse position, convert it from the scaled screen resolution
		-- to internal coordinates.
		local mx, my = unscaled(love.mouse.getPosition())

		-- Check if cursor is within the throw boundary. You can only create boxes inside the boundary,
		-- *but* you should be able to drag it out outside of the boundary.
		local bndry = lvl.throwBoundary
		local withinBoundary = checkCollision(mx,my,5,5, bndry.x, bndry.y, bndry.w, bndry.h)
		if (withinBoundary and not oldmousedown) or grabbedBall then
			-- Just started holding the mouse? Create a ball at the mouse's position,
			-- add a mouse joint to keep it static until thrown.
			if not helddown then
				ball = world:newCollider("Circle", {mx, my, 30})
				-- Set the thrown object to a "bullet", which uses more detailed collision detection
				-- to prevent it jumping over bodies if the velocity is high enough
				ball:setBullet(true)

				ball.colour = coolRandomColour()
				ball.debug_step = 0

				function ball:draw()
					local angle = self:getAngle()
					local x, y = self:getX(), self:getY()

					-- Body w/ outline
					love.graphics.circleOutlined(x, y, 30, {self.colour.r,self.colour.g,self.colour.b}, {0,0,0})

					-- Offset of the eyes from the center of the ball
					local offset = 15

					-- Eyes
					love.graphics.circleOutlined(x+math.cos(angle+math.pi/2+15)*offset, y+math.sin(angle+math.pi/2+15)*offset, 9, {1,1,1}, {0,0,0})
					love.graphics.circleOutlined(x+math.cos(angle+math.pi/2-15)*offset, y+math.sin(angle+math.pi/2-15)*offset, 9, {1,1,1}, {0,0,0})

					-- Pupil
					love.graphics.setColor(0,0,0)
					love.graphics.circle("fill", x+math.cos(angle+math.pi/2.3+15)*offset, y+math.sin(angle+math.pi/2+15)*offset, 2)
					love.graphics.circle("fill", x+math.cos(angle+math.pi/2.3-15)*offset, y+math.sin(angle+math.pi/2-15)*offset, 2)

				end

				joints.boxMouse = love.physics.newMouseJoint(ball.body, mx, my)
				joints.boxMouse:setTarget(mx, my)

				-- We now have a ball grabbed, don't boundary check anymore.
				grabbedBall = true
			end

			if ball then
				-- Now we're holding it down...
				helddown = true

				-- Calculate "throw vector", like a slingshot. It is inverse of the vector
				-- that is the difference in coordinates between the created ball and mouse.
				local ox, oy = ball:getPosition()
				throw.x = -(mx-ox)
				throw.y = -(my-oy)
			end
		end

	-- When helddown is true, but mouse is not held (i.e. mouse has been released, we're throwing it!)
	elseif helddown and joints.boxMouse then
		-- Destroy mouse joint, don't make it static anymore.
		joints.boxMouse:destroy()
		helddown = false
		grabbedBall = false
		game.ballsLeft = game.ballsLeft - 1

		-- Apply a linear impulse with the throw vector that makes the ball go wheee
		-- (hopefully crashing into some boxes ^^)
		ball:applyLinearImpulse(throw.x*30, throw.y*30)
	end

	for key, box in pairs(boxes) do
		if outOfBounds(box:getPosition()) then
			box:destroy()
			boxes[key] = nil
			boxNum = boxNum - 1
			sounds.pop:clone():play()
		end
	end

	if tableEmpty(boxes) then
		-- LAST LEVEL!!!
		if game.level == game.totalLevels then
			switchOverlay('final')
		else
			switchOverlay('success')
		end
	end

	if mouseClick() and not game.seenTutorial then
		game.seenTutorial = true
		savegame.set("seenTutorial", true)
	end
end

function scenes.game.draw()
	love.graphics.setLineWidth(2)
	love.graphics.setColor(1,1,1)

	-- Draw physics objects using Breezefield.
	world:draw()

	-- Draw the throw boundary
	local bndry = lvl.throwBoundary
	love.graphics.setLineWidth(5)
	love.graphics.rectangle('line', bndry.x, bndry.y, bndry.w, bndry.h)
	love.graphics.setLineWidth(2)

	-- Draw terrain rectangles (Breezefield is able to draw them itself but
	-- getting the representation of a Box2D shape is weird, just do it ourself).
	for _, ter in pairs(lvl.terrain) do
		love.graphics.setColor(ter.colour or { 125/256, 227/256, 102/256 })
		love.graphics.rectangle('fill', ter.x, ter.y, ter.w, ter.h)
	end

	-- If holding down, show the throw vector.
	if ball and helddown then
		local ox, oy = ball:getPosition()
		love.graphics.setColor(1,0,0)
		love.graphics.arrow(ox, oy, ox+throw.x, oy+throw.y, 10, math.pi/4)
	end

	love.graphics.setFont(fonts.sans.medium)

	love.graphics.setColor(randc.r, randc.g, randc.b)
	love.graphics.rectangle('fill', 10, 10, 40, 40)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle('line', 10, 10, 40, 40)

	love.graphics.setColor(1,1,1)

	love.graphics.print(string.format("%d/%d (%d%%)", boxNum, totalBoxes, (boxNum/totalBoxes)*100), 60, 15)

	love.graphics.setLineWidth(4)
	love.graphics.circle("line", 30, 80, 20)

	if game.ballsLeft < 1 then
		love.graphics.setColor(1,0,0)
	end

	love.graphics.print(string.format("x%d", game.ballsLeft), 60, 70)

	gtk.draw(gui)

	if not game.seenTutorial then
		love.graphics.setColor(1,1,1)
		love.graphics.draw(assets.tutorial, 0, 0, 0, 1, 1)

		love.graphics.setFont(fonts.sans.big)
		love.graphics.print("Tap and drag\nto shoot...", 40*7, 40*3)
	end
end
