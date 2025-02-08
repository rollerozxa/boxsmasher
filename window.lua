
window = {}

-- Base internal resolution
resolution = {
	x = 1280,
	y = 720
}

-- Resolution that everything is scaled up to, corresponding to the current
-- resolution of the game window
scaled_res = {
	x = resolution.x,
	y = resolution.y
}

-- Canvas offset, if aspect ratio is different
offset = {
	x = 0,
	y = 0
}

function window.draw_transformation()
	-- Offset canvas using 'offset', scale up canvas
	-- using a factor of res / base_res
	love.graphics.translate(offset.x, offset.y)
	love.graphics.scale(
		scaled_res.x / resolution.x,
		scaled_res.y / resolution.y)
end

function window.resize(w, h)
	scaled_res.x = w
	scaled_res.y = h

	-- Keep aspect ratio of canvas, don't stretch it if aspect ratio is changed
	if scaled_res.y / scaled_res.x > (resolution.y/resolution.x) then
		scaled_res.y = math.ceil(scaled_res.x * (resolution.y/resolution.x))
	else
		scaled_res.x = math.ceil(scaled_res.y * (resolution.x/resolution.y))
	end

	-- Calculate offset (canvas should be in the middle, fill the edges with void)
	offset.x = (w - scaled_res.x) / 2
	offset.y = (h - scaled_res.y) / 2
end

-- Check whether a given position is out of bounds of the window
function outOfBounds(x, y)
	local safe = 40

	return (x < -safe or x > resolution.x+safe)
		or (y < -safe or y > resolution.y+safe)
end

-- Convert a scaled coordinate into the internal counterpart. Needed when
-- grabbing the mouse's coordinate and checking against coordinates that
-- expect the internal resolution that the game is running at.
function unscaled(x, y)
	return
		(x - offset.x) / (scaled_res.x / resolution.x),
		(y - offset.y) / (scaled_res.y / resolution.y)
end

-- Convert an internal coordinate into the scaled counterpart.
function scaled(x, y)
	return
		x * scaled_res.x / resolution.x,
		y * scaled_res.y / resolution.y
end
