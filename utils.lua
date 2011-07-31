function loadResources()
	imgTiles = love.graphics.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")
	imgBG = love.graphics.newImage("res/bg.png")
	imgBG:setFilter("nearest","nearest")
	createQuads()

	font = love.graphics.newImageFont("res/tamsyn.png"," abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ.,-0123456789")
	love.graphics.setFont(font)

	pianoData = love.sound.newSoundData("res/piano.ogg")
	bassData = love.sound.newSoundData("res/bass.ogg")
	pianoTone = {}
	bassTone = {}
	setScale(cur_scale)

	sndKick = love.audio.newSource("res/kick.ogg","static")
	sndSnare = love.audio.newSource("res/snare.ogg","static")
	sndHat = love.audio.newSource("res/hat.ogg","static")
	sndRide = love.audio.newSource("res/ride.ogg","static")
	matPiano = {}
	matBass = {}
	matKick = {}
	matSnare = {}
	matHat = {}
	matRide = {}
	createPattern(1)

	tempo = {}
	for i=0,15 do
		tempo[i] = MIN_TEMPO - i*((MIN_TEMPO-MAX_TEMPO)/16)
	end
end

function createNewPattern()
	if num_pat < MAX_PAT then
		num_pat = num_pat + 1
		createPattern(num_pat)
	end
end

function createPattern(num)
	matPiano[num] = {}
	matBass[num] = {}
	matKick[num] = {}
	matSnare[num] = {}
	matHat[num] = {}
	matRide[num] = {}
	clearMatrix(matPiano[num],matBass[num])
	clearArray(matKick[num],matSnare[num],matHat[num],matRide[num])
end

function deletePattern(num)
	if num > 1 and num <= num_pat then
		local i = num
		while i < num_pat do
			matPiano[i] = matPiano[i+1]
			matBass[i] = matBass[i+1]
			matKick[i] = matKick[i+1]
			matSnare[i] = matKick[i+1]
			matHat[i] = matKick[i+1]
			matRide[i] = matKick[i+1]
			i = i+1
		end
		matPiano[i] = nil
		matBass[i] = nil
		matKick[i] = nil
		matSnare[i] = nil
		matHat[i] = nil
		matRide[i] = nil
		num_pat = num_pat - 1
		if pat > num_pat then pat = num_pat end
	end
end

function clearArray(...)
	local arr = {...}
	for i=0,15 do
		for a=1,#arr do
			arr[a][i] = 0
		end
	end
end

function clearMatrix(...)
	local mat = {...}
	for i=0,16*16-1 do
		for a=1,#mat do
			mat[a][i] = 0
		end
	end
end

function shiftMatrix(matrix,dir)
	if dir == 'wu' then
		for i=16,255 do
			matrix[i-16] = matrix[i]
			matrix[i] = 0
		end
	elseif dir == 'wd' then
		for i=255,16,-1 do
			matrix[i] = matrix[i-16]
			matrix[i-16] = 0
		end
	end
end

function createQuads()
	quad = {}
	for iy=0,7 do
		for ix=0,7 do
			quad[ix+iy*8] = love.graphics.newQuad(ix*CELLW,iy*CELLH,CELLW,CELLH,imgTiles:getWidth(),imgTiles:getHeight())
		end
	end
	bg_quad = love.graphics.newQuad(0,0,1,416,512,512)
	logo_quad = love.graphics.newQuad(1,0,106,29,512,512)
	faces_quad = love.graphics.newQuad(16,112,80,16,128,128)
end

function setScale(sc)
	for i=1,16 do
		pianoTone[i] = love.audio.newSource(pianoData)
		bassTone[i] = love.audio.newSource(bassData)
		pianoTone[i]:setPitch(freq[scale[sc][i]])
		bassTone[i]:setPitch(freq[scale[sc][i]])
	end
end

function drawTextBox(text,x,y)
	local w = math.ceil(string.len(text)*6.8)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",x-4,y-4,w,16)
	love.graphics.setColor(4,31,85,255)
	love.graphics.rectangle("fill",x-3,y-3,w-2,14)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(text,x,y)
end
