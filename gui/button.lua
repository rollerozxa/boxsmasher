
Button = {}

function Button:new(o, data)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Button:update()
	if self.isVisible and not self.isVisible()
			or (not self.isOverlay and game.overlay) then
		return
	end

	if (mouseCollisionScaled(self.x, self.y, self.w, self.h) and mouseReleased())
	or (self.keybind and love.keyboard.isDown(self.keybind) and not sparsifier[self.keybind]) then
		self.onClick()
		sounds.click:clone():play()
	end

	if self.keybind then
		sparsifier[self.keybind] = love.keyboard.isDown(self.keybind)
	end
end

function Button:draw()
	if self.isVisible and not self.isVisible() then
		return
	end

	local hovering = mouseCollisionScaled(self.x, self.y, self.w, self.h) and (self.isOverlay or not game.overlay)

	if hovering then
		if love.mouse.isDown(1) then
			love.graphics.setColor(0.05,0.05,0.05)
		else
			love.graphics.setColor(0.15,0.15,0.25)
		end
	else
		love.graphics.setColor(0.15,0.15,0.15)
	end

	-- Background
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(1,1,1)

	-- Allow for custom drawing on the button that can override the text
	if not self.onDraw or not self.onDraw() then
		love.graphics.setFont(fonts.sans.big)

		drawCenteredText(self.x, self.y+2, self.w, self.h, self.label)
	end
end
