-- Text drawing utilities

text = {}

-- Draw some text that's centered within the specified rectangle
function text.drawCentered(x, y, w, h, text)
	-- Get the current font, calculate the width and height of its
	-- glyphs to be able to center the text properly.
	local font   = love.graphics.getFont()
	local textW  = font:getWidth(text)
	local textH  = font:getHeight()

	love.graphics.print(text, x+w/2, y+h/2, 0, 1, 1, textW/2, textH/2)
end

-- Draw right aligned text
function text.drawRight(x, y, w, text)
	local font   = love.graphics.getFont()
	local textW  = font:getWidth(text)

	love.graphics.print(text, x+w-textW, y)
end

-- Draw some text that's centered within the specified rectangle, ROTATED!
function text.drawCenteredRot(x, y, w, h, text, angle)
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
function text.drawOutlined(text, x, y, rds)
	love.graphics.setColor(0,0,0)
	for oux = -rds, rds, 1 do
		for ouy = -rds, rds, 1 do
			love.graphics.print(text, x+oux, y+ouy)
		end
	end
	love.graphics.setColor(1,1,1)
	love.graphics.print(text, x, y)
end

