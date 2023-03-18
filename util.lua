
-- Background drawer helper
function drawBG(r,g,b)
	-- Copy the current coordinate transform and disable scale
	-- (Needed to draw the BG properly without influence from window scaling)
	love.graphics.push()
	love.graphics.origin()

	-- Draw background (one colour in the active area, slightly darker colour in inactive)
	love.graphics.setColor(r/1.25,g/1.25,b/1.25)
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle('fill', offset.x, offset.y, resolution.x, resolution.y)
	love.graphics.setColor(1,1,1)

	-- Restore coordinate transform
	love.graphics.pop()
end

-- State switcher helper
function switchState(state)
	game.state = state

	-- Call scene's init function, if it exists
	if scenes[game.state].init ~= nil then
		scenes[game.state].init()
	end
end

-- Axis-aligned bounding boxes (AABB) collision detection implementation
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

-- Clamp implementation (clamp x within min and max)
function math.clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

-- Draw a line with an arrow at the end.
-- 'arrlen' controls arrow length, 'angle' arrow angle
function love.graphics.arrow(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle))
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end

-- Draw rotated rectangle (angle is in radians ^^)
function rotatedRectangle(mode, x, y, width, height, angle)
	-- Push the stack, move origin of coordinate system to (x,y), rotate coord,
	-- draw the rectangle, and then pop the stack. Gosh!
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height)
	love.graphics.pop()
end

-- Generates a cool random colour.
-- Returns something like { r = 0, g = 1, b = 1 }.
-- Colour values are in decimal (represented between 0 and 1).
function coolRandomColour()
	local happy = false
	local c

	-- Repeat until I'm happy.
	while not happy do
		-- Random RGB values, clamped within 0.3 and 0.9.
		c = {
			r = math.clamp(math.random(0,1), 0.2, 0.8),
			g = math.clamp(math.random(0,1), 0.2, 0.8),
			b = math.clamp(math.random(0,1), 0.2, 0.8)
		}

		if (c.r == 0.2 and c.g == 0.2 and c.b == 0.2)
		or (c.r == 0.8 and c.g == 0.8 and c.b == 0.8) then
			-- all-black isn't a fun colour (I want something colourful!!!)
		else
			happy = true
		end
	end

	return c
end

-- Convert a scaled coordinate into the internal counterpart. Needed when
-- grabbing the mouse's coordinate and checking aginst coordinates that
-- expect the internal resolution that the game is running at.
function unscaled(x, y)
	return
		(x - offset.x) / (resolution.x / base_resolution.x),
		(y - offset.y) / (resolution.y / base_resolution.y)
end
