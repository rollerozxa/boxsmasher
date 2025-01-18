
statistics = {
	fields = {"boxes", "balls", "levels", "playtime"}
}

function statistics.add(field, value, dontMakeDirty)
	if not savegame.data.statistics[field] then
		savegame.data.statistics[field] = 0
	end
	savegame.data.statistics[field] = savegame.data.statistics[field] + value

	if not dontMakeDirty then
		savegame.dirty = true
	end
end

function statistics.get(field)
	return savegame.data.statistics[field] or 0
end
