
scenes.intro = {}

local intro_timer = 0

scenes.intro.background = { 21, 21, 21 }

function scenes.intro.init()
	intro_timer = 0
end

function scenes.intro.update(dt)
	intro_timer = intro_timer + dt

	if intro_timer > 1 or love.keyboard.isDown("escape") then
		scene.switch("mainmenu")
	end
end

function scenes.intro.draw()
	love.graphics.draw(images.intro_card, 0, 0, 0, 1, 1)
end
