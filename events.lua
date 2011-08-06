function updatePlayer(dt)
	time = time+dt
	hover = nil
	if time > wait and play == true then
		time = time%wait
		play_x = play_x+1
		if play_x == 16 then
			play_x = 0
			if state == 2 then
				song_sel = (song_sel+1)%song_len
				pat = song[song_sel]
			end
		end
		-- play piano and bass
		for iy=0,15 do
			if matPiano[pat][play_x+iy*16] == 1 then
				if pianoTone[iy+1]:isStopped() == false then pianoTone[iy+1]:stop() end
				pianoTone[iy+1]:play()
			end
			if matBass[pat][play_x+iy*16] == 1 then
				if bassTone[iy+1]:isStopped() == false then bassTone[iy+1]:stop() end
				bassTone[iy+1]:play()
			end
		end
		if matKick[pat][play_x] == 1 then
			if sndKick:isStopped() == false then sndKick:stop() end
			sndKick:play()
		end
		if matSnare[pat][play_x] == 1 then
			if sndSnare:isStopped() == false then sndSnare:stop() end
			sndSnare:play()
		end
		if matHat[pat][play_x] == 1 then
			if sndHat:isStopped() == false then sndHat:stop() end
			sndHat:play()
		end
		if matRide[pat][play_x] == 1 then
			if sndRide:isStopped() == false then sndRide:stop() end
			sndRide:play()
		end
	end
end

function updateMouse(dt)
	local mx = math.floor(love.mouse.getX()/CELLW)
	local my = math.floor(love.mouse.getY()/CELLH)
	if love.mouse.isDown('l','r') then
		local val = 1
		if love.mouse.isDown('r') then val = 0 end
		-- check first column
		if mx >= PIANO_OFF_X and mx < PIANO_OFF_X+16 then
			if my >= PIANO_OFF_Y and my < PIANO_OFF_Y+16 then
				matPiano[pat][mx-PIANO_OFF_X+(my-PIANO_OFF_Y)*16] = val
			elseif my == KICK_OFF_Y then
				matKick[pat][mx-KICK_OFF_X] = val
			elseif my == SNARE_OFF_Y then
				matSnare[pat][mx-SNARE_OFF_X] = val
			elseif my == HAT_OFF_Y then
				matHat[pat][mx-HAT_OFF_X] = val
			elseif my == RIDE_OFF_Y then
				matRide[pat][mx-RIDE_OFF_X] = val
			end
		-- check second column
		elseif mx >= BASS_OFF_X and mx < BASS_OFF_X+16 then
			-- bass
			if my >= BASS_OFF_Y and my < BASS_OFF_Y+16 then
				matBass[pat][mx-BASS_OFF_X+(my-BASS_OFF_Y)*16] = val
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

function mousePressedPlayer(x,y,button)
	local mx = math.floor(x/CELLW)
	local my = math.floor(y/CELLH)
	if button == 'l' then
		-- clear buttons - first column
		if mx == PIANO_OFF_X-1 then
			if my == PIANO_OFF_Y then
				clearMatrix(matPiano[pat])
			elseif my == KICK_OFF_Y then
				clearArray(matKick[pat])
			elseif my == SNARE_OFF_Y then
				clearArray(matSnare[pat])
			elseif my == HAT_OFF_Y then
				clearArray(matHat[pat])
			elseif my == RIDE_OFF_Y then
				clearArray(matRide[pat])
			end
		-- second column
		elseif mx == BASS_OFF_X-1 then
			if my == BASS_OFF_Y then
				clearMatrix(matBass[pat])
			end
		elseif my == PAT_OFF_Y then
			if mx >= PAT_OFF_X and mx < PAT_OFF_X+num_pat then
				if love.keyboard.isDown('lctrl','rctrl') then
					if num_pat < MAX_PAT then
						createNewPattern()
						pastePattern(mx-PAT_OFF_X+1,num_pat)
					end
				else
					pat = mx-PAT_OFF_X+1
				end
			elseif mx == PAT_OFF_X+num_pat then
				createNewPattern()
			end
		-- export to midi buton
		elseif mx == SONG_OFF_X+32 and my == SONG_OFF_Y then
			state = 3
		end
	elseif button == 'r' then
		if my == PAT_OFF_Y and mx >= PAT_OFF_X and mx < PAT_OFF_X+num_pat then
			deletePattern(mx-PAT_OFF_X+1)
		end
	elseif button == 'wu' or button == 'wd' then
		if my >= PIANO_OFF_Y and my < PIANO_OFF_Y+16 then -- same for piano and bass
			if mx >= PIANO_OFF_X and mx < PIANO_OFF_X+16 then
				shiftMatrix(matPiano[pat],button)
			elseif mx >= BASS_OFF_X and mx < BASS_OFF_X+16 then
				shiftMatrix(matBass[pat],button)
			end
		end
	end
	songMousePressed(mx,my,button)
end

function keyPressedPlayer(k,unicode)
	if k == 'c' then
		clearMatrix(matPiano[pat],matBass[pat])
		clearArray(matKick[pat],matSnare[pat],matHat[pat],matRide[pat])
	elseif k == ' ' then
		if play == true then
			play = false
		else
			play = true
			time = wait -- kind of a hack, but it works?
			play_x = 15
		end
		if state == 2 then
			state = 1
		end
	elseif k == 'return' then
		if state == 2 then
			state = 1
			play_x = 15
			time = wait
			song_scroll = 0
		elseif song_len > 0 then
			state = 2
			song_sel = song_len-1
			play = true
			time = wait
			play_x = 15
		end
	elseif unicode >= 0x31 and unicode <= 0x30 + num_pat and song_focus == false and state == 1 then
		pat = unicode - 0x30
	elseif k == 's' then
		song_focus = not song_focus
	elseif k == 'escape' then
		song_focus = false
	elseif k == 'e' then
		state = 3
	elseif k == '+' then
		createNewPattern()
	elseif k == '-' then
		deletePattern(num_pat)
	elseif k == 'c' and love.keyboard.isDown('lctrl','rctrl') then
		copy_from =	pat 
	elseif k == 'v' and love.keyboard.isDown('lctrl','rctrl') then
		pastePattern(copy_from,pat)
	end
	if song_focus then
		songKeyPressed(k,unicode)
	end
end

function keyPressedSave(k,uni)
	if uni >= 0x21 and uni <= 0x7A then
		filename = filename:sub(1,caret) .. string.char(uni) .. filename:sub(caret+1)
		caret = caret +1 
	elseif k == 'left' then
		if caret > 0 then
			caret = caret - 1
		end
	elseif k == 'right' then
		if caret < filename:len() then
			caret = caret + 1
		end
	elseif k == 'backspace' then
		if caret > 0 then
			filename = filename:sub(1,caret-1) .. filename:sub(caret+1)
			caret = caret-1
		end
	elseif k == 'delete' then
		if caret < filename:len() and filename:len() > 0 then
			filename = filename:sub(1,caret) .. filename:sub(caret+2)
		end
	elseif k == 'return' then
		writeToMidi()
		state = 1
	end
end
