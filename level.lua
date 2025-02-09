-- Level handling functionality
-- (TODO: Refactor more stuff into here)

function levelByNumber(level)
	if level < 10 then
		return "levels/0" .. level .. ".lua"
	end
	return "levels/" .. level .. ".lua"
end

function getTotalLevels()
	local totalLevels = 0
	while true do
		if love.filesystem.getInfo(levelByNumber(totalLevels + 1)) then
			totalLevels = totalLevels + 1
		else
			break
		end
	end

	return totalLevels
end
