
colour = {}

local boxColours = {
  --{0,0,0}, -- Black
	{0,0,1}, -- Blue
	{0,1,0}, -- Green
	{0,1,1}, -- Cyan
	{1,0,0}, -- Red
	{1,0,1}, -- Magenta
	{1,1,0}, -- Yellow
  --{1,1,1}, -- White
}

local boxColoursClamped = nil

-- Generates a random colour within a list of box colours
function colour.random()
	if dbg.isEnabled("autorestart") then
		return {0.2, 0.2, 0.8}
	end

	if boxColoursClamped == nil then
		boxColoursClamped = {}
		for i = 1, #boxColours, 1 do
			local colour = boxColours[i]
			boxColoursClamped[i] = {
				math.clamp(colour[1], 0.2, 0.8),
				math.clamp(colour[2], 0.2, 0.8),
				math.clamp(colour[3], 0.2, 0.8),
			}
		end
	end

	return boxColoursClamped[math.random(#boxColoursClamped)]
end
