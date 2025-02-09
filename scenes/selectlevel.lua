-- Select level scene

local selectlevel = {
	background = { 44, 100, 141 },
	gui = Gui:new()
}

-- Limit the amount of levels
local levelsAvailable

-- Checks if player can play level, depending on levels unlocked.
local function canPlay(levelnum)
	return (levelnum <= savegame.get("levelsUnlocked"))
end

function selectlevel.init()
	levelsAvailable = getTotalLevels()

	selectlevel.gui:add("back", TexButton:new{
		x = 0, y = 0,
		w = 128, h = 64,
		scale = 0.5,
		texture = "back_btn",
		onClick = function()
			scene.switch("mainmenu")
		end,
		keybind = "escape"
	})

	for levelnum = 1, levelsAvailable do
		local cx = ((levelnum - 1) % 8) + 1
		local cy = math.floor((levelnum - 1) / 8)

		selectlevel.gui:add("lvl_"..levelnum, Button:new{
			x = cx * 150 - 80, y = 128 + cy * 150,
			w = 96, h = 96,
			onDraw = function(x,y)
				love.graphics.setFont(fonts.sans.bigger)

				if canPlay(levelnum) then
					-- If player can play level, print the level number.
					love.graphics.print(levelnum, x + 10, y + 2)
				else
					-- Otherwise, draw a lock icon
					love.graphics.draw(images.lock, x, y, 0, 0.75, 0.75)
				end

				-- Draw checkmark for completed levels (all unlocked levels except for the
				-- last one would have been completed.
				if canPlay(levelnum+1) then
					love.graphics.draw(images.lvlok, x, y, 0, 0.75, 0.75)
				end

				return true
			end,
			onClick = function()
				if canPlay(levelnum) then
					scene.switch("game", { level = levelnum })
					sound.play("click")
				end
			end
		})
	end
end

function selectlevel.back()
	scene.switch("mainmenu")
end

return selectlevel
