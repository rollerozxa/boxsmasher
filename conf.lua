
function love.conf(t)
	t.identity = "BoxSmasher"
	t.version = "11.4"

	t.window.title = "Box Smasher"
	t.window.icon = "data/icon.png"
	t.window.width = 1280
	t.window.height = 720
	t.window.borderless = false
	if love._os == "Android" then
		t.window.resizable = false
	else
		t.window.resizable = true
	end
	--t.window.minwidth = 320
	--t.window.minheight = 180

	t.modules.video = false
end
