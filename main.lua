require("freq")
require("defines")
require("utils")
require("export")
require("draw")
require("update")

function love.load()
	time = 0
	play_x = 0
	cur_tempo = 8
	cur_scale = 1
	num_pat = 1
	pat = 1
	play = true
	song = {}
	song_focus = false
	song_sel = 0
	song_len = 0
	song_scroll = 0
	state = 1 -- see defines.lua for states
	filename = 'export.mid'
	caret = filename:len()
	loadResources()
	wait = tempo[cur_tempo]
end

function love.update(dt)
	if state == 1 or state == 2 then
		updatePlayer(dt)
		updateMouse(dt)
	end
end

function love.draw()
	if state == 1 or state == 2 then
		drawPlayer()
	elseif state == 3 then
		drawPlayer()
		drawSave()
	end
end

function love.keypressed(k,unicode)
	if state == 1 or state == 2 then
		keyPressedPlayer(k,unicode)
	elseif state == 3 then
		keyPressedSave(k,unicode)
	end
end

function love.mousepressed(x,y,button)
	if state == 1 or state == 2 then
		mousePressedPlayer(x,y,button)
	end
end

function love.mousereleased(x,y,button)
-- use released instead of pressed to
-- avoid drawing underneath
	if state == 3 then
		mouseReleasedSave(x,y,button)
	end
end
