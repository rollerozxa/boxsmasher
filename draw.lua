
draw = {}

-- Draw a googly-eyed ball
function draw.ball(x, y, angle, colour, radius)
	radius = radius or 30

	love.graphics.setLineWidth(2)

	-- Body w/ outline
	draw.circleOutlined(x, y, radius, colour, {0,0,0})

	-- Offset of the eyes from the center of the ball
	local offset = radius/2

	-- Eyes
	draw.circleOutlined(
		x+math.cos(angle+math.pi/2+15)*offset,
		y+math.sin(angle+math.pi/2+15)*offset,
		radius*0.3, {1,1,1}, {0,0,0})

	draw.circleOutlined(
		x+math.cos(angle+math.pi/2-15)*offset,
		y+math.sin(angle+math.pi/2-15)*offset,
		radius*0.3, {1,1,1}, {0,0,0})

	-- Pupil
	love.graphics.setColor(0,0,0)
	love.graphics.circle("fill",
		x+math.cos(angle+math.pi/2.3+15)*offset,
		y+math.sin(angle+math.pi/2+15)*offset,
		2)
	love.graphics.circle("fill",
		x+math.cos(angle+math.pi/2.3-15)*offset,
		y+math.sin(angle+math.pi/2-15)*offset,
		2)
end

-- Draw a box
function draw.box(x, y, w, h, angle, colour)

	-- Box fill
	love.graphics.setColor(colour)
	draw.rotatedRectangle('fill', x, y, w, h, angle)

	-- Box outline
	love.graphics.setColor(0,0,0)
	draw.rotatedRectangle('line', x, y, w, h, angle)

	if dbg.isEnabled('box_pos') then
		love.graphics.setColor(1,1,1)
		love.graphics.setFont(fonts.sans.tiny)
		love.graphics.print('{'..math.floor(x)..','..math.floor(y)..'}', x, y)
	end
end

-- Draw the background rectangle
function draw.background(r, g, b)
	-- Copy the current coordinate transform and disable scale
	-- (Needed to draw the BG properly without influence from window scaling)
	love.graphics.push()
	love.graphics.origin()

	-- Draw background, keeping in mind the potential offset currently happening.
	love.graphics.setColor(r, g, b)
	love.graphics.rectangle('fill', offset.x, offset.y, scaled_res.x, scaled_res.y)
	love.graphics.setColor(1,1,1)

	-- Restore coordinate transform
	love.graphics.pop()
end

-- Draw the background letterbox
function draw.backgroundLetterbox(r, g, b)
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

-- Draw a line with an arrow at the end.
-- 'arrlen' controls arrow length, 'angle' arrow angle
function draw.arrow(x1, y1, x2, y2, arrlen, angle)
	love.graphics.line(x1, y1, x2, y2)
	local a = math.atan2(y1 - y2, x1 - x2)
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a + angle), y2 + arrlen * math.sin(a + angle))
	love.graphics.line(x2, y2, x2 + arrlen * math.cos(a - angle), y2 + arrlen * math.sin(a - angle))
end

function draw.circleOutlined(x, y, radius, oc, fc)
	love.graphics.setColor(oc)
	love.graphics.circle("fill", x, y, radius)
	love.graphics.setColor(fc)
	love.graphics.circle("line", x, y, radius)
end

-- Draw rotated rectangle (angle is in radians ^^)
function draw.rotatedRectangle(mode, x, y, width, height, angle)
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height)
	love.graphics.pop()
end
