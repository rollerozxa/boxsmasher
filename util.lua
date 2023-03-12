
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
