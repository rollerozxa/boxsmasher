-- Final level completion overlay

local final = {
	gui = Gui:new()
}

function final.init()
	final.gui:add("back", Button:new{
		x = 480, y = 40*13,
		w = 40*8, h = 96,
		label = S("yay ^-^"),
		onClick = function()
			overlay.switch(false)
			scene.switch("selectlevel")
		end,
		isOverlay = true
	})

	sound.play("success")
end

function final.back()
	overlay.switch(false)
	scene.switch("selectlevel")
end

local text = {
	"Congratulations, you've",
	"completed all the levels",
	"currently in the game!",
	"",
	"Stay tuned for new updates",
	"with more levels..."}

function final.draw()
	love.graphics.setColor(64/255, 120/255, 161/255,0.9)
	love.graphics.rectangle('fill', 380, 20, 520, 680)

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(fonts.sans.bigger)
	text.drawCentered(4, 64, resolution.x, 64, S("Level Complete!"))

	love.graphics.setFont(fonts.sans.medium)
	local y = 32*5
	for _,t in pairs(text) do
		text.drawCentered(0, y, resolution.x, 32, t)
		y = y + 48
	end
end

return final
