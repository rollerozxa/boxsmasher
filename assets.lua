
assets = {}

function assets.loadImages()
	local images = {}

	for _, entry in ipairs(json.decodefile("data/images/images.json")) do
		local image = love.graphics.newImage("data/images/"..entry.name..".png")
		if entry.filter then
			image:setFilter(entry.filter, entry.filter)
		end
		images[entry.name] = image
	end

	return images
end

function assets.loadFonts()
	local fontdata = json.decodefile("data/fonts/fonts.json")

	local fonts = {}

	for id, name in pairs(fontdata.faces) do
		fonts[id] = {}

		for sizename, size in pairs(fontdata.sizes) do
			fonts[id][sizename] = love.graphics.newFont("data/fonts/"..name..".ttf", size)
		end
	end

	return fonts
end

function assets.loadSounds()
	local sounds = {}

	for _, entry in ipairs(json.decodefile("data/sounds/sounds.json")) do
		local audio = love.audio.newSource("data/sounds/"..entry.name..".ogg", entry.type or "static")

		sounds[entry.name] = audio
	end

	return sounds
end
