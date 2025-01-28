
local intro = {
	background = { 21, 21, 21 }
}

local intro_timer = 0

function intro.init()
	intro_timer = 0
end

function intro.update(dt)
	intro_timer = intro_timer + dt

	if intro_timer > 0.5 or love.keyboard.isDown("escape") then
		scene.switch("mainmenu")
	end
end

function intro.draw()
	love.graphics.draw(images.intro_raccoon, 0, 0, 0, 1, 1)
	love.graphics.draw(images.intro_text, 0, 0, 0, 1, 1)
end

return intro
