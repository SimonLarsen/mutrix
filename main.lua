require("defines")
require("utils")

function love.load()
	love.graphics.setMode(37*CELLW,23*CELLW)
	love.graphics.setBackgroundColor(bgcolor)
	love.graphics.setLineWidth(2)
	math.randomseed(os.time())
	loadResources()

	update = 0
	play_x = 0
	cur_tempo = 8
	wait = tempo[cur_tempo]
end

function love.update(dt)
	-- play
	update=update+dt
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
	if love.mouse.isDown('l','r') then
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		local val = 1
		if love.mouse.isDown('r') then val = 0 end
		
		-- check first column instruments
		if mx >= PIANO_OFF_X*CELLW and mx < (PIANO_OFF_X+16)*CELLW then
			local cx = math.floor((mx-PIANO_OFF_X*CELLW)/CELLW)
			-- piano
			if	my >= PIANO_OFF_Y*CELLH and my < (PIANO_OFF_Y+16)*CELLH then
				local cy = math.floor((my-PIANO_OFF_Y*CELLH)/CELLH)
				matPiano[cx+cy*16] = val
			-- kick
			elseif my >= KICK_OFF_Y*CELLH and my < (KICK_OFF_Y+1)*CELLH then
				matKick[cx] = val
			-- snare
			elseif my >= SNARE_OFF_Y*CELLH and my < (SNARE_OFF_Y+1)*CELLH then
				matSnare[cx] = val	
			-- hat
			elseif my >= HAT_OFF_Y*CELLH and my < (HAT_OFF_Y+1)*CELLH then
				matHat[cx] = val
			elseif my >= RIDE_OFF_Y*CELLH and my < (RIDE_OFF_Y+1)*CELLH then
				matRide[cx] = val
			end
		-- check second column
		elseif mx >= BASS_OFF_X*CELLW and mx < (BASS_OFF_X+16)*CELLW then
			-- bass
			local cx = math.floor((mx-BASS_OFF_X*CELLW)/CELLW)
			if my >= BASS_OFF_Y*CELLH and my < (BASS_OFF_Y+16)*CELLH then
				local cy = math.floor((my-BASS_OFF_Y*CELLH)/CELLH)
				matBass[cx+cy*16] = val
			-- tempo
			elseif my >= TEMPO_OFF_Y*CELLH and my < (TEMPO_OFF_Y+1)*CELLH then
				cur_tempo = cx
				wait = tempo[cur_tempo]
			end
		end
	end
end

function love.draw()
	love.graphics.setColor(255,255,255,255)
	-- draw icons
	love.graphics.drawq(imgTiles,quad[0],CELLW,PIANO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[8],CELLW,KICK_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[16],CELLW,SNARE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[24],CELLW,HAT_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[32],CELLW,RIDE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[40],(BASS_OFF_X-1)*CELLW,BASS_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[48],(TEMPO_OFF_X-1)*CELLW,TEMPO_OFF_Y*CELLH)

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
end

function love.keypressed(k)
	if k == ' ' then
		clearPatterns()
	end
end
