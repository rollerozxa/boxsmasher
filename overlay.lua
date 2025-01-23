
overlay = {}

overlays = {}

local curOverlay = false

local overlayInitData = {}

-- Overlay switcher helper
function overlay.switch(overlay, data)
	-- Ignore call if we're already on the same overlay
	if curOverlay == overlay then return end

	curOverlay = overlay
	overlayInitData = data or {}

	if curOverlay and overlays[curOverlay].init ~= nil then
		overlays[curOverlay].init(overlayInitData)
	end
end

function overlay.isActive()
	return curOverlay ~= false
end

function overlay.runBack()
	if overlays[curOverlay].back ~= nil then
		overlays[curOverlay].back()
	end
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
