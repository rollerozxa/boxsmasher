-- Level completion overlay

local success = {
	gui = Gui:new()
}

local level, ballsUsed, totalBalls

function success.init(data)
	success.gui:add("back", Button:new{
		x = 390, y = 540,
		w = 200, h = 96,
		label = S("Back"),
		onClick = function()
			overlay.switch(false)
			scene.switch("selectlevel")
		end,
		isOverlay = true
	})

	success.gui:add("next", Button:new{
		x = 620, y = 540,
		w = 270, h = 96,
		label = S("Next level"),
		onClick = function()
			overlay.switch(false)
			scene.switch("game", {level = level + 1})
		end,
		isOverlay = true
	})

	sound.play("success")

	level = data.level
	ballsUsed = data.ballsUsed
	totalBalls = data.totalBalls
end

function success.back()
	overlay.switch(false)
	scene.switch("selectlevel")
end

function success.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	drawCenteredText(4, 64, base_resolution.x, 64, S("Level Complete!"))

	local texts = {
		S("Level: %d", level),
		S("Balls used: %d/%d", ballsUsed, totalBalls)
	}

	love.graphics.setFont(fonts.sans.medium)
	for i = 1, #texts, 1 do
		love.graphics.print(texts[i], 420, 4*32+(i*72))
	end
end

return success
