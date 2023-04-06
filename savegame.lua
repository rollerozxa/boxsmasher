
-- savegame.lua: Provides a simple key/value datastore for persisting data between game starts.

-- The data is serialised into JSON and gets saved into a file whenever a value is changed.

savegame = {
	data = {}
}

-- Load an existing savegame JSON file, if it exists.
function savegame.load()
	local savejson = love.filesystem.read("savedata.json")
	if savejson ~= nil then
		savegame.data = json.decode(savejson)
	end
end

-- Save the current data to file. Keep in mind this is usually
-- done automatically by savegame.set().
function savegame.save()
	love.filesystem.write("savedata.json", json.encode(savegame.data))
end

-- Get the value of 'key'
function savegame.get(key)
	return savegame.data[key]
end

-- Set the value of 'key' to 'value'
function savegame.set(key, value)
	savegame.data[key] = value
	savegame.save()
end
