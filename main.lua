require("defines")
require("utils")

function love.load()
	update = 0
	play_x = 0
	cur_tempo = 8
	cur_scale = 1
	wait = tempo[cur_tempo]

	loadResources()
end

function love.update(dt)
	-- play
	update=update+dt
	hover = nil
	if update > wait then
		update = update%wait
		play_x = (play_x+1)%16
		-- play piano and bass
		for iy=0,15 do
			if matPiano[play_x+iy*16] == 1 then
				if pianoTone[iy+1]:isStopped() == false then pianoTone[iy+1]:stop() end
				pianoTone[iy+1]:play()
			end
			if matBass[play_x+iy*16] == 1 then
				if bassTone[iy+1]:isStopped() == false then bassTone[iy+1]:stop() end
				bassTone[iy+1]:play()
			end
		end
		if matKick[play_x] == 1 then
			if sndKick:isStopped() == false then sndKick:stop() end
			sndKick:play()
		end
		if matSnare[play_x] == 1 then
			if sndSnare:isStopped() == false then sndSnare:stop() end
			sndSnare:play()
		end
		if matHat[play_x] == 1 then
			if sndHat:isStopped() == false then sndHat:stop() end
			sndHat:play()
		end
		if matRide[play_x] == 1 then
			if sndRide:isStopped() == false then sndRide:stop() end
			sndRide:play()
		end
	end
	-- check mouse
	local mx = math.floor(love.mouse.getX()/CELLW)
	local my = math.floor(love.mouse.getY()/CELLH)
	if love.mouse.isDown('l','r') then
		local val = 1
		if love.mouse.isDown('r') then val = 0 end
		-- check first column
		if mx >= PIANO_OFF_X and mx < PIANO_OFF_X+16 then
			if my >= PIANO_OFF_Y and my < PIANO_OFF_Y+16 then
				matPiano[mx-PIANO_OFF_X+(my-PIANO_OFF_Y)*16] = val
			elseif my == KICK_OFF_Y then
				matKick[mx-KICK_OFF_X] = val
			elseif my == SNARE_OFF_Y then
				matSnare[mx-SNARE_OFF_X] = val
			elseif my == HAT_OFF_Y then
				matHat[mx-HAT_OFF_X] = val
			elseif my == RIDE_OFF_Y then
				matRide[mx-RIDE_OFF_X] = val
			end
		-- check second column
		elseif mx >= BASS_OFF_X and mx < BASS_OFF_X+16 then
			-- bass
			if my >= BASS_OFF_Y and my < BASS_OFF_Y+16 then
				matBass[mx-BASS_OFF_X+(my-BASS_OFF_Y)*16] = val
			-- tempo bar
			elseif my == TEMPO_OFF_Y then
				cur_tempo = mx-TEMPO_OFF_X
				wait = tempo[cur_tempo]
			end
		end
	end
	-- check scale hover and clicks
	if my == SCALE_OFF_Y then
		for i = 0,4 do
			if i+SCALE_OFF_X == mx then
				hover = {scale_name[i+1],love.mouse.getX()+16,love.mouse.getY()+16}
				if love.mouse.isDown('l') and cur_scale-1 ~= i then
					cur_scale = i+1
					setScale(cur_scale)
				end
			end
		end
	end
end

function love.draw()
	love.graphics.setColor(255,255,255,255)
	-- draw background
	love.graphics.drawq(imgBG,bg_quad,0,0,0,592,1)
	love.graphics.drawq(imgBG,logo_quad,32,21)
	-- draw icons
	love.graphics.drawq(imgTiles,quad[0],CELLW,PIANO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[8],CELLW,KICK_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[16],CELLW,SNARE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[24],CELLW,HAT_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[32],CELLW,RIDE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[40],(BASS_OFF_X-1)*CELLW,BASS_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[48],(TEMPO_OFF_X-1)*CELLW,TEMPO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[56],(SCALE_OFF_X-1)*CELLW,SCALE_OFF_Y*CELLH)

	love.graphics.push()
	-- draw piano matrix
	love.graphics.translate(PIANO_OFF_X*CELLW,PIANO_OFF_Y*CELLH)
	for iy=0,15 do
		for ix=0,15 do
			if ix == play_x then
				love.graphics.drawq(imgTiles,quad[18+matPiano[ix+iy*16]],ix*CELLW,iy*CELLH)
			else
				love.graphics.drawq(imgTiles,quad[17+matPiano[ix+iy*16]],ix*CELLW,iy*CELLH)
			end
		end
	end
	love.graphics.pop()
	-- draw drum matrices
	love.graphics.push()
	love.graphics.setColor(255,255,255,255)
	love.graphics.translate(KICK_OFF_X*CELLW,KICK_OFF_Y*CELLH)
	for x=0,15 do
		if x == play_x then
			love.graphics.drawq(imgTiles,quad[2+matKick[x]],x*CELLW,0)
			love.graphics.drawq(imgTiles,quad[10+matSnare[x]],x*CELLW,CELLH)
			love.graphics.drawq(imgTiles,quad[26+matHat[x]],x*CELLW,2*CELLH)
			love.graphics.drawq(imgTiles,quad[18+matRide[x]],x*CELLW,3*CELLH)
		else
			love.graphics.drawq(imgTiles,quad[1+matKick[x]],x*CELLW,0)
			love.graphics.drawq(imgTiles,quad[9+matSnare[x]],x*CELLW,CELLH)
			love.graphics.drawq(imgTiles,quad[25+matHat[x]],x*CELLW,2*CELLH)
			love.graphics.drawq(imgTiles,quad[17+matRide[x]],x*CELLW,3*CELLH)
		end
	end
	love.graphics.pop()
	-- draw bass matrix
	love.graphics.push()
	love.graphics.translate(BASS_OFF_X*CELLW,BASS_OFF_Y*CELLH)
	for iy=0,15 do
		for ix=0,15 do
			if ix == play_x then
				love.graphics.drawq(imgTiles,quad[26+matBass[ix+iy*16]],ix*CELLW,iy*CELLH)
			else
				love.graphics.drawq(imgTiles,quad[25+matBass[ix+iy*16]],ix*CELLW,iy*CELLH)
			end
		end
	end
	love.graphics.pop()
	-- draw BPM slider
	love.graphics.push()
	love.graphics.translate(TEMPO_OFF_X*CELLW,TEMPO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[4],0,0)
	for i=1,14 do
		love.graphics.drawq(imgTiles,quad[5],i*CELLW,0)
	end
	love.graphics.drawq(imgTiles,quad[6],15*CELLW,0)
	love.graphics.drawq(imgTiles,quad[7],cur_tempo*CELLW,0)
	love.graphics.pop()
	-- draw scale buttons
	love.graphics.push()
	love.graphics.translate(SCALE_OFF_X*CELLW,SCALE_OFF_Y*CELLH)
	for	i=0,4 do
		if i+1 == cur_scale then
			love.graphics.drawq(imgTiles,quad[2],i*CELLW,0)
		else
			love.graphics.drawq(imgTiles,quad[1],i*CELLW,0)
		end
	end
	love.graphics.drawq(imgTiles,faces_quad,0,0)
	love.graphics.pop()
	-- draw hover
	if hover ~= nil then
		drawTextBox(hover[1],hover[2],hover[3])
	end
end

function love.keypressed(k)
	if k == ' ' then
		clearPatterns()
	end
end

function love.mousepressed(x,y,button)
	-- left mouse button
	local mx = math.floor(x/CELLW)
	local my = math.floor(y/CELLH)
	if button == 'l' then
		-- clear buttons - first column
		if mx == PIANO_OFF_X-1 then
			if my == PIANO_OFF_Y then
				clearMatrix(matPiano)
			elseif my == KICK_OFF_Y then
				clearArray(matKick)
			elseif my == SNARE_OFF_Y then
				clearArray(matSnare)
			elseif my == HAT_OFF_Y then
				clearArray(matHat)
			elseif my == RIDE_OFF_Y then
				clearArray(matRide)
			end
		-- second column
		elseif mx == BASS_OFF_X-1 then
			if my == BASS_OFF_Y then
				clearMatrix(matBass)
			end
		end
	elseif button == 'wu' or button == 'wd' then
		if my >= PIANO_OFF_Y and my < PIANO_OFF_Y+16 then -- same for piano and bass
			if mx >= PIANO_OFF_X and mx < PIANO_OFF_X+16 then
				shiftMatrix(matPiano,button)
			elseif mx >= BASS_OFF_X and mx < BASS_OFF_X+16 then
				shiftMatrix(matBass,button)
			end
		end
	end
end
