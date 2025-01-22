-- breezefield: init.lua
--[[
	implements Collider and World objects
	Collider wraps the basic functionality of shape, fixture, and body
	World wraps world, and provides automatic drawing simplified collisions
]]--

local bf = {}

local Collider = require('lib/breezefield/collider')
local World = require('lib/breezefield/world')

bf.Collider = Collider
bf.World = World

return bf
