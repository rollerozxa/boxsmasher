
local lvl = {
	author = 'ROllerozxa',
	ballsLeft = 2,
	throwBoundary = {
		x = 40*1.5, y = 40*3,
		w = 40*5.5, h = 40*11,
	},
	boxclusters = {},
	terrain = {
		{
			x = 40*12, y = 40*13.5,
			w = 40*10, h = 40*2
		}
	}
}

for i = 1, 7, 1 do
	local fY = 40*2 + 60*i

	table.insert(lvl.boxclusters, {
		x = 40*12, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 40*15, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 40*18, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 40*21, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})

	table.insert(lvl.boxclusters, {
		x = 40*12, y = fY-20,
		w = 40*5, h = 20,
		aX = 2, aY = 1
	})
end

return lvl
