-- gtk.lua: Basic GUI toolkit that allows putting clickable buttons with callbacks and labels onto the screen.

-- The format is a table, here is an example of the format:
--[[
	local gui = {
		some_btn = {
			type = "button",
			x = 96, y = 8*32,
			size = { x = 160, y = 32 },
			label = "Button Label",
			on_click = function()
				-- do stuff when clicked
			end
			is_visible = function()
				-- if defined, can control whether the element is visible
			end
		}
	}
]]

gtk = {}

local sparsifier = {}

function gtk.update(gui, is_overlay)
	for id, el in pairs(gui) do
		local elt = el.type
		-- Allow hiding elements with an .is_visible() callback.
		if el.is_visible and not el.is_visible()
			or (not is_overlay and game.overlay)
		then
			elt = "none"
		end

		if elt == "button" or elt == "tex_button" then
			if (mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and mouseReleased())
			or (el.keybind and love.keyboard.isDown(el.keybind) and not sparsifier[id]) then
				el.on_click()
				sounds.click:clone():play()
			end

			if el.keybind then
				sparsifier[id] = love.keyboard.isDown(el.keybind)
			end
		end

	end
end

function gtk.draw(gui, is_overlay)
	for id, el in pairs(gui) do
		local elt = el.type
		-- Allow hiding elements with an .is_visible() callback.
		if el.is_visible and not el.is_visible() then
			elt = "none"
		end

		local hovering = mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and (is_overlay or not game.overlay)

		if elt == "button" then
			if hovering then
				if love.mouse.isDown(1) then
					love.graphics.setColor(0.05,0.05,0.05)
				else
					love.graphics.setColor(0.15,0.15,0.25)
				end
			else
				love.graphics.setColor(0.15,0.15,0.15)
			end

			-- Background
			love.graphics.rectangle("fill", el.x, el.y, el.size.x, el.size.y)

			love.graphics.setColor(1,1,1)

			-- Allow for custom drawing on the button that can override the text
			if not el.on_draw or not el.on_draw() then
				love.graphics.setFont(fonts.sans.big)

				drawCenteredText(el.x, el.y+2, el.size.x, el.size.y, el.label)
			end
		elseif elt == "tex_button" then
			if hovering then
				if love.mouse.isDown(1) then
					love.graphics.setColor(0.1,0.1,0.1)
				else
					love.graphics.setColor(0.75,0.75,0.75)
				end
			else
				love.graphics.setColor(1,1,1)
			end

			if not el.scale then
				el.scale = 1
			end

			love.graphics.draw(assets[el.texture], el.x, el.y, 0, el.scale, el.scale)
		elseif elt == "label" then
			love.graphics.setColor(1,1,1)

			love.graphics.print(el.label, el.x, el.y)
		end
	end
end
