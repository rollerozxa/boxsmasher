
draw = {}

function draw.ball(x, y, angle, colour, radius)
	radius = radius or 30

	love.graphics.setLineWidth(2)

	-- Body w/ outline
	love.graphics.circleOutlined(x, y, radius, {colour.r,colour.g,colour.b}, {0,0,0})

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

function draw.box(x, y, w, h, angle, colour)

	-- Box fill
	love.graphics.setColor(colour.r, colour.g, colour.b)
	rotatedRectangle('fill', x, y, w, h, angle)

	-- Box outline
	love.graphics.setColor(0,0,0)
	rotatedRectangle('line', x, y, w, h, angle)

	if dbg.box_pos.enabled then
		love.graphics.setColor(1,1,1)
		love.graphics.setFont(fonts.sans.tiny)
		love.graphics.print('{'..math.floor(x)..','..math.floor(y)..'}', self:getX(), self:getY())
	end
end
