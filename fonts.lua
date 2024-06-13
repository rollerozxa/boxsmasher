-- fonts.lua: Font loading

local function newFont(name, size)
	return love.graphics.newFont("fonts/"..name..".ttf", size)
end

function initFonts()

	local fontfaces = {sans = 'undefined-medium'}

	local fontsizes = {
		tiny = 10,
		small = 20,
		medium = 30,
		big = 40,
		bigger = 50,
		biggest = 90}

	local fonts = {}

	for id, name in pairs(fontfaces) do
		fonts[id] = {}

		for sizename, size in pairs(fontsizes) do
			fonts[id][sizename] = newFont(name, size)
		end
	end

	return fonts
end
