function loadResources()
	imgTiles = love.graphics.newImage("res/tiles.png")
	imgBG = love.graphics.newImage("res/bg.png")
	imgTiles:setFilter("nearest","nearest")
	createQuads()

	pianoData = love.sound.newSoundData("res/piano.ogg")
	bassData = love.sound.newSoundData("res/bass.ogg")
	pianoTone = {}
	bassTone = {}
	for i=1,#freq do
		pianoTone[i] = love.audio.newSource(pianoData)
		bassTone[i] = love.audio.newSource(bassData)
		pianoTone[i]:setPitch(freq[i])
		bassTone[i]:setPitch(freq[i])
	end
	sndKick = love.audio.newSource("res/kick.ogg","static")
	sndSnare = love.audio.newSource("res/snare.ogg","static")
	sndHat = love.audio.newSource("res/hat.ogg","static")
	sndRide = love.audio.newSource("res/ride.ogg","static")
	matPiano = {}
	matKick = {}
	matSnare = {}
	matHat = {}
	matRide = {}
	matBass = {}
	clearPatterns()
end

function clearPatterns()
	for iy=0,15 do
		for ix=0,15 do
			matPiano[ix+iy*16] = 0
			matBass[ix+iy*16] = 0
		end
		matKick[iy] = 0
		matSnare[iy] = 0
		matHat[iy] = 0
		matRide[iy] = 0
		matBass[iy] = 0
	end
end

function createQuads()
	quad = {}
	for iy=0,7 do
		for ix=0,7 do
			quad[ix+iy*8] = love.graphics.newQuad(ix*CELLW,iy*CELLH,CELLW,CELLH,imgTiles:getWidth(),imgTiles:getHeight())
		end
	end
end
