
draw = {}

-- Draw a googly-eyed ball
function draw.ball(x, y, angle, colour, radius)
	radius = radius or 30

	love.graphics.setLineWidth(2)

	-- Body w/ outline
	love.graphics.circleOutlined(x, y, radius, colour, {0,0,0})

	-- Offset of the eyes from the center of the ball
	local offset = radius/2

	-- Eyes
	love.graphics.circleOutlined(
		x+math.cos(angle+math.pi/2+15)*offset,
		y+math.sin(angle+math.pi/2+15)*offset,
		radius*0.3, {1,1,1}, {0,0,0})

	love.graphics.circleOutlined(
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
	rotatedRectangle('fill', x, y, w, h, angle)

	-- Box outline
	love.graphics.setColor(0,0,0)
	rotatedRectangle('line', x, y, w, h, angle)

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
