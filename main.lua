freq = {1.682, 1.414, 1.2599, 1.1246, 0.944, 0.8409, 0.7071, 0.62996,
		0.561228, 0.4719, 0.4204, 0.3534, 0.31499, 0.2806, 0.2360, 0.2102}

WAIT = 0.200

CELLW,CELLH = 16,16

PIANO_OFF_X = 2
PIANO_OFF_Y = 1
KICK_OFF_X = 2
KICK_OFF_Y = 18
SNARE_OFF_X = 2
SNARE_OFF_Y = 19
HAT_OFF_X = 2
HAT_OFF_Y = 20
RIDE_OFF_X = 2
RIDE_OFF_Y = 21

bgcolor = {54,110,212}

function love.load()
	love.graphics.setMode(19*CELLW,23*CELLW)
	love.graphics.setBackgroundColor(bgcolor)
	love.graphics.setLineWidth(2)
	math.randomseed(os.time())
	loadResources()

	update = 0
	play_x = 0
end

function love.update(dt)
	-- play
	update=update+dt
	if update > WAIT then
		update = update%WAIT
		play_x = (play_x+1)%16
		-- play piano
		for iy=0,15 do
			if matPiano[play_x+iy*16] == 1 then
				if pianoTone[iy+1]:isStopped() == false then pianoTone[iy+1]:stop() end
				pianoTone[iy+1]:play()
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
		end
	end
end

function love.draw()
	love.graphics.setColor(255,255,255,255)
	-- draw icons
	love.graphics.drawq(imgTiles,quad[1],CELLW,PIANO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[0],CELLW,KICK_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[2],CELLW,SNARE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[12],CELLW,HAT_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[3],CELLW,RIDE_OFF_Y*CELLH)

	love.graphics.push()
	-- draw piano matrix
	love.graphics.translate(PIANO_OFF_X*CELLW,PIANO_OFF_Y*CELLH)
	for iy=0,15 do
		for ix=0,15 do
			love.graphics.drawq(imgTiles,quad[6+matPiano[ix+iy*16]],ix*CELLW,iy*CELLH)
		end
	end
	love.graphics.setColor(0,0,0,255)
	local lx = (play_x+update/WAIT)*CELLW
	love.graphics.line(lx,0,lx,16*CELLH)
	love.graphics.pop()
	-- draw drum matrices
	love.graphics.setColor(255,255,255,255)
	love.graphics.translate(KICK_OFF_X*CELLW,KICK_OFF_Y*CELLH)
	for x=0,15 do
		love.graphics.drawq(imgTiles,quad[10+matKick[x]],x*CELLW,0)
		love.graphics.drawq(imgTiles,quad[4+matSnare[x]],x*CELLW,CELLH)
		love.graphics.drawq(imgTiles,quad[8+matHat[x]],x*CELLW,2*CELLH)
		love.graphics.drawq(imgTiles,quad[14+matRide[x]],x*CELLW,3*CELLH)
	end
end

function love.keypressed(k)
	if k == ' ' then
		for iy=0,15 do
			for ix=0,15 do
				matPiano[ix+iy*16] = 0
			end
			matKick[iy] = 0
			matSnare[iy] = 0
			matHat[iy] = 0
			matRide[iy] = 0
		end
	end
end

function loadResources()
	imgTiles = love.graphics.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")
	quad = {}
	for iy=0,3 do
		for ix=0,3 do
			quad[ix+iy*4] = love.graphics.newQuad(ix*CELLW,iy*CELLH,CELLW,CELLH,imgTiles:getWidth(),imgTiles:getHeight())
		end
	end

	pianoData = love.sound.newSoundData("res/piano.ogg")
	pianoTone = {}
	for i=1,#freq do
		pianoTone[i] = love.audio.newSource(pianoData)
		pianoTone[i]:setPitch(freq[i])
	end
	matPiano = {}
	for iy=0,15 do
		for ix=0,15 do
			matPiano[ix+iy*16] = 0
		end
	end

	sndKick = love.audio.newSource("res/kick.ogg","static")
	sndSnare = love.audio.newSource("res/snare.ogg","static")
	sndHat = love.audio.newSource("res/hat.ogg","static")
	sndRide = love.audio.newSource("res/ride.ogg","static")
	matKick = {}
	matSnare = {}
	matHat = {}
	matRide = {}
	for x=0,15 do
		matKick[x] = 0
		matSnare[x] = 0
		matHat[x] = 0
		matRide[x] = 0
	end
end
