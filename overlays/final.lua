-- Final level completion overlay

overlays.final = {}

local backBtn = Button:new{
	x = 480, y = 40*13,
	w = 40*8, h = 96,
	label = S("yay ^-^"),
	onClick = function()
		overlay.switch(false)
		scene.switch("selectlevel")
	end,
	isOverlay = true
}

function overlays.final.init()
	sounds.success:clone():play()

	-- If this is the latest level, unlock the next level.
	if game.level == game.levelsUnlocked then
		game.levelsUnlocked = game.levelsUnlocked + 1
		savegame.set('levelsUnlocked', game.levelsUnlocked)
	end
end

function overlays.final.update()
	backBtn:update()
end

local text = {
	"Congratulations, you've",
	"completed all the levels",
	"currently in the game!",
	"",
	"Stay tuned for new updates",
	"with more levels..."}

function overlays.final.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	drawCenteredText(4, 64, base_resolution.x, 64, S("Level Complete!"))

	love.graphics.setFont(fonts.sans.medium)
	local y = 32*5
	for _,t in pairs(text) do
		drawCenteredText(0, y, base_resolution.x, 32, t)
		y = y + 48
	end

	backBtn:draw()
end
