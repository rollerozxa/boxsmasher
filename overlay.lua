
overlay = {}

overlays = {}

local curOverlay = false

-- Overlay switcher helper
function overlay.switch(overlay)
	-- Ignore call if we're already on the same overlay
	if curOverlay == overlay then return end

	curOverlay = overlay

	if curOverlay and overlays[curOverlay].init ~= nil then
		overlays[curOverlay].init()
	end
end

function overlay.isActive()
	return curOverlay ~= false
end

function overlay.runUpdate(dt)
	if curOverlay then
		if overlays[curOverlay].update ~= nil then
			overlays[curOverlay].update(dt)
		end
	end
end

function overlay.runDraw()
	if curOverlay then
		if overlays[curOverlay].draw ~= nil then
			overlays[curOverlay].draw()
		end
	end
end
