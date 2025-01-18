local json = require("../lib/json") -- Replace with your preferred JSON library
local threadChannel = love.thread.getChannel("savegame_channel")

while true do
	local saveData = threadChannel:demand()
	if saveData then
		love.filesystem.write("savedata.json", json.encode(saveData))
	end
end
