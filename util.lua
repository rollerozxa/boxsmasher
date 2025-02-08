-- Miscellaneous utility functions

function json.decodefile(file)
	return json.decode(love.filesystem.read(file))
end

-- Check if a table is empty
function tableEmpty(self)
    for _, _ in pairs(self) do
        return false
    end

    return true
end

-- Split a string into a table on newlines
function splitNewline(str)
	local tbl = {}
	for s in str:gmatch("[^\r\n]+") do
		table.insert(tbl, s)
	end
	return tbl
end

-- Axis-aligned bounding boxes (AABB) collision detection implementation
function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return	x1 < x2+w2
		and	x2 < x1+w1
		and	y1 < y2+h2
		and	y2 < y1+h1
end

-- Clamp implementation (clamp x within min and max)
function math.clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

-- Dummy translation function
-- (Future proofing for when a translation system is implemented)
function S(text, ...)
	return string.format(text, ...)
end
