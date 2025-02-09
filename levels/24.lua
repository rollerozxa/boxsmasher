
return {
	author = 'ROllerozxa',
	totalBalls = 3,
	throwBoundary = {
		x = 40*13.75, y = 40*7,
		w = 40*4.5, h = 40*7,
	},
	boxclusters = {
		{
			x = 40*6, y = 40*4,
			w = 40, h = 40,
			aX = 5, aY = 12
		}, {
			x = 40*21, y = 40*4,
			w = 40, h = 40,
			aX = 5, aY = 12
		},
	},
	terrain = {
		{
			x = 40*6, y = 40*16,
			w = 40*5, h = 40*2,
			friction = 0.75
		}, {
			x = 40*21, y = 40*16,
			w = 40*5, h = 40*2,
			friction = 0.75
		}, {
			x = 0, y = 40*3,
			w = 40, h = 40*12,
			colour = { 209, 156, 56 },
			restitution = 2
		},
	}
}
