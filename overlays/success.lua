-- Level completion overlay

overlays.success = {}

local backBtn = Button:new{
	x = 390, y = 540,
	w = 200, h = 96,
	label = S("Back"),
	onClick = function()
		switchOverlay(false)
		switchState("selectlevel")
	end,
	isOverlay = true
}

local nextBtn = Button:new{
	x = 620, y = 540,
	w = 270, h = 96,
	label = S("Next level"),
	onClick = function()
		-- Increment level and restart game scene, so next level is played.
		game.level = game.level + 1

		switchOverlay(false)
		switchState("game")
	end,
	isOverlay = true
}

function overlays.success.init()
	sounds.success:clone():play()

	-- If this is the latest level, unlock the next level.
	if game.level == game.levelsUnlocked then
		game.levelsUnlocked = game.levelsUnlocked + 1
		savegame.set('levelsUnlocked', game.levelsUnlocked)
	end
end

function overlays.success.update()
	backBtn:update()
	nextBtn:update()
end

function overlays.success.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	drawCenteredText(4, 64, base_resolution.x, 64, S("Level Complete!"))

	local texts = {
		S("Level: %s", game.level),
	}

	love.graphics.setFont(fonts.sans.medium)
	for i = 1, #texts, 1 do
		love.graphics.print(texts[i], 420, 4*32+(i*48))
	end

	backBtn:draw()
	nextBtn:draw()
end
