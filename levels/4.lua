
-- Author: ROllerozxa

local lvl = {
	ballsLeft = 2,
	throwBoundary = {
		x = 60, y = 120,
		w = 220, h = 440,
	},
	boxclusters = {

	},
	terrain = {
		{
			x = 480, y = 540,
			w = 40*10, h = 80
		}
	}
}

for i = 1, 7, 1 do
	local fY = 80 + 60*i

	table.insert(lvl.boxclusters, {
		x = 480, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 600, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 720, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})
	table.insert(lvl.boxclusters, {
		x = 840, y = fY,
		w = 40, h = 40,
		aX = 1, aY = 1
	})

	table.insert(lvl.boxclusters, {
		x = 480, y = fY-20,
		w = 5*40, h = 20,
		aX = 2, aY = 1
	})
end

return lvl
