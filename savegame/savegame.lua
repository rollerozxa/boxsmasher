-- Provides a simple key/value datastore for persisting data between game starts.
-- The data is serialised into JSON and gets saved into a file whenever a value is changed.

savegame = {
	data = {},
	dirty = false
}

savegame.data.statistics = {}

local threadChannel, saveThread

-- Load an existing savegame JSON file, if it exists.
function savegame.load()
	local savejson = love.filesystem.read("savedata.json")
	if savejson ~= nil then
		savegame.data = json.decode(savejson)
	end

	threadChannel = love.thread.getChannel("savegame_channel")
	saveThread = love.thread.newThread("savegame/save_thread.lua")
    saveThread:start()
end

-- Save the current data to file. Keep in mind this is usually
-- done automatically by savegame.set().
function savegame.save()
	threadChannel:push(savegame.data)
end

local saveDelta = 0
function savegame.runSaveTimer(dt)
	saveDelta = saveDelta + dt

	statistics.add("playtime", dt, true)

	if (saveDelta > 5 and savegame.dirty) or saveDelta > 60 then
		saveDelta = 0
		savegame.save()
	end
end

function savegame.setDefault(key, value)
	if savegame.data[key] == nil then
		savegame.data[key] = value
	end
end

-- Get the value of 'key'
function savegame.get(key)
	return savegame.data[key]
end

-- Set the value of 'key' to 'value'
function savegame.set(key, value)
	savegame.data[key] = value
	savegame.dirty = true
end
