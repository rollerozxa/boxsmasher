
-- selectlevel.lua: Select level scene

scenes.selectlevel = {}

local gui = {
	back_button = {
		type = "tex_button",
		x = 0, y = 0,
		size = { x = 128, y = 64 },
		scale = 0.5,
		texture = "back_btn",
		on_click = function()
			switchState("mainmenu")
		end,
		keybind = "escape"
	},
}

-- Checks if player can play level, depending on levels unlocked
-- and levelpacks unlocked.
function canPlay(levelnum)
	return (levelnum <= game.levelsUnlocked)
end

function scenes.selectlevel.update()
	gtk.update(gui)

	for i = 0,24 do
		local x = (i % 5) + 1
		local y = math.floor(i / 5)
		local levelnum = i + 1

		if mouseCollisionScaled(x * 150 - 80, 128 + y * 150, 96, 96) and mouseClick() and canPlay(levelnum) then
			game.level = levelnum
			switchState("game")
			sounds.click:clone():play()
		end
	end
end

function scenes.selectlevel.draw()
	drawBG(64/255, 120/255, 161/255)

	gtk.draw(gui)

	love.graphics.setFont(fonts.sans.bigger)

	for i = 0,31 do
		local x = (i % 8) + 1
		local y = math.floor(i / 8)
		local levelnum = i + 1

		if mouseCollisionScaled(x * 150 - 80, 128 + y * 150, 96, 96) then
			love.graphics.setColor(0,0,0.1)
		else
			love.graphics.setColor(0.1,0.1,0.1)
		end

		love.graphics.rectangle('fill', x * 150 - 80, 128 + y * 150, 96, 96)

		love.graphics.setColor(1,1,1)
		if canPlay(levelnum) then
			love.graphics.print(levelnum, x * 150 - 80, 128 + y * 150)
		else
			love.graphics.draw(assets.lock, x * 150 - 80, 128 + y * 150, 0, 0.75, 0.75)
		end

		if canPlay(levelnum+1) then
			love.graphics.draw(assets.lvlok, x * 150 - 80, 128 + y * 150, 0, 0.5, 0.5)
		end
	end
end
