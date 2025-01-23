
scenes = {}
scene = {}

local curScene = "mainmenu"

local trans = false
local trans_step = 0
local trans_to = ""
local trans_alpha = 0

function scene.switch(scene)
	if trans then return end

	trans = true
	trans_step = 0
	trans_to = scene
end

function scene.restart()
	scene.switch(curScene)
end

function scene.runInit()
	if scenes[curScene].init ~= nil then
		scenes[curScene].init()
	end
end

function scene.runUpdate(dt)
	if scenes[curScene].update ~= nil then
		scenes[curScene].update(dt)
	end
end

function scene.runDraw()
	local bg
	if scenes[curScene].draw ~= nil then
		if scenes[curScene].background then
			bg = scenes[curScene].background

			draw.background(love.math.colorFromBytes(bg[1], bg[2], bg[3]))
		end

		scenes[curScene].draw()
	end

	if scenes[curScene].background then
		draw.backgroundLetterbox(love.math.colorFromBytes(bg[1], bg[2], bg[3]))
	end
end

function scene.isTransitioning()
	return trans
end

function scene.performTransition()
	if not trans then return end

	if trans_step < 25 then
		trans_alpha = trans_alpha + 10
	else
		trans_alpha = trans_alpha - 10
	end

	love.graphics.setColor(0,0,0,trans_alpha/255)

	love.graphics.push()
	love.graphics.origin()

	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.pop()

	trans_step = trans_step + 1

	if trans_step == 25 then
		curScene = trans_to

		if scenes[curScene].init ~= nil then
			scenes[curScene].init()
		end
	elseif trans_step == 50 then
		trans = false
	end
end
