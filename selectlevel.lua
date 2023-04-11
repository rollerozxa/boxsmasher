
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

-- Checks if player can play level, depending on levels unlocked.
function canPlay(levelnum)
	return (levelnum <= game.levelsUnlocked)
end

function scenes.selectlevel.update()
	gtk.update(gui)

	-- Iterate over all the grid cells and check for mouse click.
	for i = 0,31 do
		-- Cool maths to determine the coordinate of the cell and the level number.
		local x = (i % 8) + 1
		local y = math.floor(i / 8)
		local levelnum = i + 1

		-- Check that mouse is within the specific grid, is clicked, and the level clicked is playable.
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

	-- Iterate over all the grid cells and draw them.
	for i = 0,31 do
		-- Cool maths to determine the coordinate of the cell and the level number.
		local x = (i % 8) + 1
		local y = math.floor(i / 8)
		local levelnum = i + 1

		-- Hover feedback
		if mouseCollisionScaled(x * 150 - 80, 128 + y * 150, 96, 96) then
			love.graphics.setColor(0,0,0.1)
		else
			love.graphics.setColor(0.1,0.1,0.1)
		end

		-- Draw button rectangle
		love.graphics.rectangle('fill', x * 150 - 80, 128 + y * 150, 96, 96)

		love.graphics.setColor(1,1,1)

		if canPlay(levelnum) then
			-- If player can play level, print the level number.
			love.graphics.print(levelnum, x * 150 - 70, 130 + y * 150)
		else
			-- Otherwise, draw a lock icon (to signify the level has not yet been unlocked)
			love.graphics.draw(assets.lock, x * 150 - 80, 128 + y * 150, 0, 0.75, 0.75)
		end

		-- Through a perculiar turn of events, level completion can be checked by seeing if
		-- the next level is unlocked. If it is not unlocked, then it is the newest unlocked
		-- level, and the player hasn't completed it yet.
		if canPlay(levelnum+1) then
			love.graphics.draw(assets.lvlok, x * 150 - 80, 128 + y * 150, 0, 0.75, 0.75)
		end
	end
end
