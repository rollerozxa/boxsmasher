
-- Basic GUI toolkit that allows putting clickable buttons
-- with callbacks and labels onto the screen.

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

function gtk.update(gui)
	for id, el in pairs(gui) do
		-- Allow hiding elements with an .is_visible() callback.
		if el.is_visible and not el.is_visible() then
			-- Override type to "none" to preserve indentation
			el.type = "none"
		end

		if el.type == "button"
			or el.type == "tex_button" then
			if (mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) and mouseClick())
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

function gtk.draw(gui)
	for id, el in pairs(gui) do
		-- Allow hiding elements with an .is_visible() callback.
		if el.is_visible and not el.is_visible() then
			-- Override type to "none" to preserve indentation
			el.type = "none"
		end

		if el.type == "button" then
			if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) then
				love.graphics.setColor(0,0,0.1)
			else
				love.graphics.setColor(0.1,0.1,0.1)
			end

			love.graphics.rectangle("fill", el.x, el.y, el.size.x, el.size.y)
			love.graphics.setColor(1,1,1)
			-- Allow for custom drawing on the button that can override the text
			if not el.on_draw or not el.on_draw() then
				love.graphics.setFont(fonts.sans.big)
				drawCenteredText(el.x, el.y+2, el.size.x, el.size.y, el.label)
			end
		elseif el.type == "tex_button" then
			if mouseCollisionScaled(el.x, el.y, el.size.x, el.size.y) then
				love.graphics.setColor(0.1,0.1,0.1)
			else
				love.graphics.setColor(1,1,1)
			end

			if not el.scale then
				el.scale = 1
			end

			love.graphics.draw(assets[el.texture], el.x, el.y, 0, el.scale, el.scale)
		elseif el.type == "label" then
			love.graphics.setColor(1,1,1)

			love.graphics.print(el.label, el.x, el.y)
		end
	end
end
