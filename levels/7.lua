
-- Author: ROllerozxa

return {
	ballsLeft = 2,
	throwBoundary = {
		x = 40*2, y = 40*5,
		w = 40*6, h = 40*10,
	},
	boxclusters = {
		-- First pyramid (bottom to up)
		{
			x = 40*12, y = 40*15,
			w = 40, h = 40,
			aX = 7, aY = 1
		}, {
			x = 40*12.5, y = 40*14,
			w = 40, h = 40,
			aX = 6, aY = 1
		}, {
			x = 40*13, y = 40*13,
			w = 40, h = 40,
			aX = 5, aY = 1
		}, {
			x = 40*13.5, y = 40*12,
			w = 40, h = 40,
			aX = 4, aY = 1
		}, {
			x = 40*14, y = 40*11,
			w = 40, h = 40,
			aX = 3, aY = 1
		}, {
			x = 40*14.5, y = 40*10,
			w = 40, h = 40,
			aX = 2, aY = 1
		}, {
			x = 40*15, y = 40*9,
			w = 40, h = 40,
			aX = 1, aY = 1
		},

		-- Second pyramid (bottom to up)
		{
			x = 40*20, y = 40*15,
			w = 40, h = 40,
			aX = 7, aY = 1
		}, {
			x = 40*20.5, y = 40*14,
			w = 40, h = 40,
			aX = 6, aY = 1
		}, {
			x = 40*21, y = 40*13,
			w = 40, h = 40,
			aX = 5, aY = 1
		}, {
			x = 40*21.5, y = 40*12,
			w = 40, h = 40,
			aX = 4, aY = 1
		}, {
			x = 40*22, y = 40*11,
			w = 40, h = 40,
			aX = 3, aY = 1
		}, {
			x = 40*22.5, y = 40*10,
			w = 40, h = 40,
			aX = 2, aY = 1
		}, {
			x = 40*23, y = 40*9,
			w = 40, h = 40,
			aX = 1, aY = 1
		},

		-- Third pyramid (bottom to up)
		{
			x = 40*16, y = 40*8,
			w = 40, h = 40,
			aX = 7, aY = 1
		}, {
			x = 40*16.5, y = 40*7,
			w = 40, h = 40,
			aX = 6, aY = 1
		}, {
			x = 40*17, y = 40*6,
			w = 40, h = 40,
			aX = 5, aY = 1
		}, {
			x = 40*17.5, y = 40*5,
			w = 40, h = 40,
			aX = 4, aY = 1
		}, {
			x = 40*18, y = 40*4,
			w = 40, h = 40,
			aX = 3, aY = 1
		}, {
			x = 40*18.5, y = 40*3,
			w = 40, h = 40,
			aX = 2, aY = 1
		}, {
			x = 40*19, y = 40*2,
			w = 40, h = 40,
			aX = 1, aY = 1
		},

		-- Support pillar between first layer and second layer
		{
			x = 40*16, y = 40*9,
			w = 40*7, h = 40,
			aX = 1, aY = 1
		}
	},
	terrain = {
		{
			x = 480, y = 40*16,
			w = 40*15, h = 80
		}
	}
}
