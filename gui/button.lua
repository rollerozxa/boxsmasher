
Button = {}

function Button:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Button:update()
	if self.isVisible and not self.isVisible()
			or (not self.isOverlay and overlay.isActive()) then
		return
	end

	if (mouseCollisionScaled(self.x, self.y, self.w, self.h) and mouseReleased())
	or (self.keybind and love.keyboard.isDown(self.keybind) and not sparsifier[self.keybind]) then
		sound.play("click")
		self.onClick(self)
	end

	if self.keybind then
		sparsifier[self.keybind] = love.keyboard.isDown(self.keybind)
	end
end

function Button:draw()
	if self.isVisible and not self.isVisible() then
		return
	end

	local hovering = mouseCollisionScaled(self.x, self.y, self.w, self.h) and (self.isOverlay or not overlay.isActive())

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
	if self.onDraw and self.onDraw(self.x, self.y, self.w, self.h) then
		return
	end

	if self.image then
		local image = images[self.image.name]
		local scale = {
			x = self.image.w / image:getWidth(),
			y = self.image.h / image:getHeight()
		}

		love.graphics.draw(image, self.x + ((self.w-self.image.w)/2), self.y + ((self.h-self.image.h)/2), 0, scale.x, scale.y)
	else
		if #self.label > 25 then
			love.graphics.setFont(fonts.sans.medium)
		else
			love.graphics.setFont(fonts.sans.big)
		end

		text.drawCentered(self.x, self.y+7, self.w, self.h, self.label)
	end
end
