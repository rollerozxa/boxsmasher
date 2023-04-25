
-- debug.lua: Debug utilities

-- (Called avlusn(ing) to not collide with Lua's debug ^^)
-- To enable debugging options in Android, you can hardcode the option to be enabled and push to your device.

return {
	-- Draw coordinates, and visualise the current cursor position both scaled and unscaled.
	coords = {
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

			love.graphics.print("Gosh, coords!\n"..table.concat(coord), 5, 460)
		end
	},

	grid = {
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

			love.graphics.print("Debug Grid On", 5, 460)
		end
	},

	info = {
		enabled = false,
		keybind = 'f',
		draw = function()
			love.graphics.setFont(fonts.sans.small)
			local c = coolRandomColour()
			love.graphics.setColor(c.r,c.g,c.b)
			love.graphics.print("Gosh, debug! FPS: "..love.timer.getFPS()..", Running at "..resolution.x.."x"..resolution.y, 5, 10)

			local mx, my = love.mouse.getPosition()
			math.randomseed(mx+my)
			love.graphics.print("interesting numbers: "..math.random()..", "..math.random()..", "..math.random()..". Gosh!", 5, resolution.y-25)
		end
	},

	box_pos = {
		enabled = false,
		keybind = 'p',
		draw = function()
			-- nothing
		end
	},

	phys_pause = {
		enabled = false,
		keybind = 'i',
		draw = function()
			love.graphics.print("Physics iteration paused", 500, 0)
		end
	}
}
