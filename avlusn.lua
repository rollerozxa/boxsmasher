
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

			local resolution = {
				x = love.graphics.getWidth(),
				y = love.graphics.getHeight()
			}

			love.graphics.setLineWidth(4)
			love.graphics.setColor(0,1,0)
			love.graphics.line(mx, 0, mx, resolution.y)
			love.graphics.line(umx, 0, umx, resolution.y)
			love.graphics.setColor(1,0.1,0.1)
			love.graphics.line(0, my, resolution.x, my)
			love.graphics.line(0, umy, resolution.x, umy)
			love.graphics.setLineWidth(1)

			love.graphics.setColor(1,1,1)

			local coord = {"scaled = {",mx,",",my,"}, unscaled = {",umx,",",umy,"}"}

			love.graphics.print("Gosh, coords!\n"..table.concat(coord), 5, 460)
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
	}
}
