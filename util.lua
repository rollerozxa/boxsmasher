-- Miscellaneous utility functions

function json.decodefile(file)
	return json.decode(love.filesystem.read(file))
end

-- Check if a table is empty
function tableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end

    return true
end

-- Split a string into a table on newlines
function splitNewline(str)
	local tbl = {}
	for s in str:gmatch("[^\r\n]+") do
		table.insert(tbl, s)
	end
	return tbl
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

function love.graphics.circleOutlined(x, y, radius, oc, fc)
	love.graphics.setColor(oc)
	love.graphics.circle("fill", x, y, radius)
	love.graphics.setColor(fc)
	love.graphics.circle("line", x, y, radius)
end

-- Draw rotated rectangle (angle is in radians ^^)
function rotatedRectangle(mode, x, y, width, height, angle)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height)
	love.graphics.pop()
end

-- Generates a cool random colour.
function coolRandomColour()
	if dbg.isEnabled("autorestart") then
		return {0.2, 0.2, 0.8}
	end

	local happy = false
	local c

	-- Repeat until I'm happy.
	while not happy do
		-- Random RGB values, clamped within 0.3 and 0.9.
		c = {
			math.clamp(math.random(0,1), 0.2, 0.8),
			math.clamp(math.random(0,1), 0.2, 0.8),
			math.clamp(math.random(0,1), 0.2, 0.8)
		}

		if (c[1] == 0.2 and c[2] == 0.2 and c[3] == 0.2)
		or (c[1] == 0.8 and c[2] == 0.8 and c[3] == 0.8) then
			-- all-black isn't a fun colour (I want something colourful!!!)
		else
			happy = true
		end
	end

	return c
end

-- Draw some text that's centered within the specified rectangle
function drawCenteredText(x, y, w, h, text)
	-- Get the current font, calculate the width and height of its
	-- glyphs to be able to center the text properly.
	local font   = love.graphics.getFont()
	local textW  = font:getWidth(text)
	local textH  = font:getHeight()

	love.graphics.print(text, x+w/2, y+h/2, 0, 1, 1, textW/2, textH/2)
end

function drawRightText(x, y, w, text)
	local font   = love.graphics.getFont()
	local textW  = font:getWidth(text)

	love.graphics.print(text, x+w-textW, y)
end

-- Draw some text that's centered within the specified rectangle, ROTATED!
function drawCenteredTextRot(x, y, w, h, text, angle)
	-- Get the current font, calculate the width and height of its
	-- glyphs to be able to center the text properly.
	local font   = love.graphics.getFont()
	local textW  = font:getWidth(text)
	local textH  = font:getHeight()

	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.print(text, x+w/2, y+h/2, 0, 1, 1, textW/2, textH/2)
	love.graphics.pop()
end

-- Print text with an outline that extends to the outside of the text glyphs.
function printOutlined(text, x, y, rds)
	love.graphics.setColor(0,0,0)
	for oux = -rds, rds, 1 do
		for ouy = -rds, rds, 1 do
			love.graphics.print(text, x+oux, y+ouy)
		end
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print(text, x, y)
end

-- Check if mouse is inside of the specified rectangle, give or take a small safe area.
function mouseCollision(x,y,w,h)
	-- Safe area around the cursor that still treats it as a press
	local safearea = 8
	return checkCollision(
		x+offset.x, y+offset.y, w, h,
		love.mouse.getX()-safearea, love.mouse.getY()-safearea, safearea*2, safearea*2)
end

-- mouseCollision() but scaled
function mouseCollisionScaled(x,y,w,h)
	local x, y = scaled(x, y)
	local w, h = scaled(w, h)
	return mouseCollision(x, y, w, h)
end

-- Sparsified check for mouse click (not held down).
function mouseClick()
	return love.mouse.isDown(1) and not oldmousedown
end

function mouseReleased()
	return not love.mouse.isDown(1) and oldmousedown
end
