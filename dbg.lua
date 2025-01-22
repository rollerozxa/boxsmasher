-- Debug utilities

local _dbg = {}

-- Draw coordinates, and visualise the current cursor position both scaled and unscaled.
_dbg.coords = {
	enabled = false,
	keybind = 'c',
	draw = function()
		love.graphics.setFont(fonts.sans.small)
		local mx, my = love.mouse.getPosition()
		local umx, umy = unscaled(love.mouse.getPosition())

		love.graphics.setLineWidth(4)
		love.graphics.setColor(0,1,0)
		love.graphics.line(mx, 0, mx, base_resolution.y)
		love.graphics.line(umx, 0, umx, base_resolution.y)
		love.graphics.setColor(1,0.1,0.1)
		love.graphics.line(0, my, base_resolution.x, my)
		love.graphics.line(0, umy, base_resolution.x, umy)

		love.graphics.setColor(1,1,0)
		love.graphics.rectangle("line", 0, 0, resolution.x, resolution.y)
		love.graphics.rectangle("line", 0, 0, base_resolution.x, base_resolution.y)

		love.graphics.setColor(1,1,1)
		love.graphics.setLineWidth(1)

		local coord = {"scaled = {",mx,",",my,"}\nunscaled = {",umx,",",umy,"}\nozxa units = {",math.floor(mx/40),",",math.floor(my/40),"}"}

		love.graphics.print(table.concat(coord), 5, 460)
	end
}

_dbg.grid = {
	enabled = false,
	keybind = 'g',
	draw = function()
		love.graphics.setColor(0,1,1)
		love.graphics.setLineWidth(1)
		local cellSize = 40

		for x = cellSize, base_resolution.x, cellSize do
			love.graphics.line(x, 0, x, base_resolution.y)
		end

		for y = cellSize, base_resolution.y, cellSize do
			love.graphics.line(0, y, base_resolution.x, y)
		end
	end
}

_dbg.info = {
	enabled = false,
	keybind = 'f',
	draw = function()
		love.graphics.setFont(fonts.sans.small)
		love.graphics.print("FPS: "..love.timer.getFPS()..", Running at "..resolution.x.."x"..resolution.y, 5, 10)
	end
}

_dbg.box_pos = {
	enabled = false,
	keybind = 'p',
	draw = function()
		-- nothing
	end
}

_dbg.phys_pause = {
	enabled = false,
	keybind = 'i',
	draw = function()
		love.graphics.print("Physics iteration paused", 500, 0)
	end
}

_dbg.restart = {
	enabled = false,
	keybind = 'r',
	draw = function()
		scene.restart()
		dbg.restart.enabled = false
	end
}

dbg = {}

function dbg.runUpdate()
	if not love.keyboard.isDown('f3') then return end

	for id, def in pairs(_dbg) do
		if love.keyboard.isDown(def.keybind) and not sparsifier[def.keybind] then
			_dbg[id].enabled = not _dbg[id].enabled
		end
		sparsifier[def.keybind] = love.keyboard.isDown(def.keybind)
	end
end

-- Call draw functions for enabled debug options
function dbg.runDraw()
	for _, def in pairs(_dbg) do
		if def.enabled then
			love.graphics.setColor(1,1,1)
			love.graphics.setFont(fonts.sans.medium)
			def.draw()
		end
	end
end

function dbg.isEnabled(option)
	return _dbg[option].enabled
end
