
sound = {}

function sound.play(name)
	if savegame.get("enableSound") then
		-- Clone the sound object so multiple can be played
		-- at the same time. This shouldn't duplicate the memory usage, I think.
		sounds[name]:clone():play()
	end
end
