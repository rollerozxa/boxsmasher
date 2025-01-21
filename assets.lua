
assets = {}

function assets.loadImages()
	local newImage = function(name)
		return love.graphics.newImage("data/images/"..name..".png")
	end

	return {
		back_btn = newImage("back_btn"),
		lvlok = newImage("lvlok"),
		lock = newImage("lock"),
		menu = newImage("menu"),
		tutorial = newImage("tutorial")
	}
end

function assets.loadFonts()
	local newFont = function(name, size)
		return love.graphics.newFont("data/fonts/"..name..".ttf", size)
	end

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

function assets.loadSounds()
	local newSound = function(name)
		return love.audio.newSource("data/sounds/"..name..".ogg", "static")
	end

	return {
		click = newSound("click"),
		pop = newSound("pop"),
		spawn = newSound("spawn"),
		success = newSound("success"),
		throw = newSound("throw")
	}
end
