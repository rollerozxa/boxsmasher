-- Level handling functionality
-- (TODO: Refactor more stuff into here)

function getTotalLevels()
	local totalLevels = 0
	while true do
		if love.filesystem.getInfo("levels/"..(totalLevels+1)..".lua") then
			totalLevels = totalLevels + 1
		else
			break
		end
	end

	return totalLevels
end
