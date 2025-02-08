-- Misc. user input utilities

oldmousedown = false

-- Keeps track of held down keys to prevent repeating actions.
sparsifier = {}


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

