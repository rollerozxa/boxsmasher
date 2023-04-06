
-- success.lua: Level complete overlay shown on level completion.

overlays.success = {}

local gui = {
	back = {
		type = "button",
		x = 390, y = 540,
		size = { x = 200, y = 96 },
		label = S("Back"),
		on_click = function()
			switchOverlay(false)
			switchState("mainmenu")
		end
	},

	nextlevel = {
		type = "button",
		x = 620, y = 540,
		size = { x = 270, y = 96 },
		label = S("Next level"),
		on_click = function()
			-- Increment level and restart game scene, so next level is played.
			game.level = game.level + 1

			switchOverlay(false)
			switchState("game")
		end
	}
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
	gtk.update(gui, true)
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

	gtk.draw(gui, true)
end
