
Gui = {}

function Gui:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.elements = {}
	return o
end

function Gui:add(name, obj)
	self.elements[name] = obj
end

function Gui:update()
	for _, element in pairs(self.elements) do
		element:update()
	end
end

function Gui:draw()
	for _, element in pairs(self.elements) do
		element:draw()
	end
end
