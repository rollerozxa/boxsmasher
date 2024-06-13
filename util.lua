-- util.lua: Miscellaneous utility functions.

-- Background drawer helper
function drawBG(r,g,b)
	-- Copy the current coordinate transform and disable scale
	-- (Needed to draw the BG properly without influence from window scaling)
	love.graphics.push()
	love.graphics.origin()

	-- Draw background, keeping in mind the potential offset currently happening.
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle('fill', offset.x, offset.y, resolution.x, resolution.y)
	love.graphics.setColor(1,1,1)

	-- Restore coordinate transform
	love.graphics.pop()
end

function drawBGLetterbox(r,g,b)
	-- Copy the current coordinate transform and disable scale
	-- (Needed to draw the BG properly without influence from window scaling)
	love.graphics.push()
	love.graphics.origin()

	-- Draw the letterboxed background of the side, if the aspect ratio isn't 16:9.
	-- The letterboxed "void" is slightly darker and is drawn on top in order to cover
	-- objects falling into the void, hence why this was split up from drawBG().
	love.graphics.setColor(r/1.25,g/1.25,b/1.25)
	love.graphics.rectangle('fill', 0, 0, offset.x, love.graphics.getHeight())
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), offset.y)
	love.graphics.rectangle('fill', love.graphics.getWidth()-offset.x, 0, offset.x, love.graphics.getHeight())
	love.graphics.rectangle('fill', 0, love.graphics.getHeight()-offset.y, love.graphics.getWidth(), offset.y)

	love.graphics.setColor(1,1,1)

	-- Restore coordinate transform
	love.graphics.pop()
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

-- State switcher helper
function switchState(state)
	game.state = state

	if scenes[game.state].init ~= nil then
		scenes[game.state].init()
	end
end

-- Overlay switcher helper
function switchOverlay(state)
	-- Ignore call if we're already on the same overlay
	if game.overlay == state then return end

	game.overlay = state

	if game.overlay and overlays[game.overlay].init ~= nil then
		overlays[game.overlay].init()
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

-- Check whether a given position is out of bounds
function outOfBounds(x,y)
	local safe = 40

	return (x < -safe or x > base_resolution.x+safe)
		or (y < -safe or y > base_resolution.y+safe)
end

-- Helper function to load in an image file
function newImage(filename)
	return love.graphics.newImage("assets/"..filename..".png")
end

-- Helper function to load in a sound file
function newSound(filename)
	return love.audio.newSource("sounds/"..filename..".ogg", "static")
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
	-- Safe area around the cursor that still treats it as a press, for fat fingered fucks
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

-- Convert an internal coordinate into the scaled counterpart.
function scaled(x,y)
	return
		x * resolution.x / base_resolution.x,
		y * resolution.y / base_resolution.y
end

-- Sparsified check for mouse click (not held down).
function mouseClick()
	return love.mouse.isDown(1) and not oldmousedown
end
