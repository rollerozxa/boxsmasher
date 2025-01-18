
TexButton = Button:new()

function TexButton:draw()
	local hovering = mouseCollisionScaled(self.x, self.y, self.w, self.h) and (self.is_overlay or not game.overlay)

	if hovering then
		if love.mouse.isDown(1) then
			love.graphics.setColor(0.1,0.1,0.1)
		else
			love.graphics.setColor(0.75,0.75,0.75)
		end
	else
		love.graphics.setColor(1,1,1)
	end

	love.graphics.draw(images[self.texture], self.x, self.y, 0,
		self.scale or 1, self.scale or 1)
end
