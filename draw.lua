function drawPlayer()
	love.graphics.setColor(255,255,255,255)
	-- draw background
	love.graphics.drawq(imgBG,bg_quad,0,0,0,592,1)
	love.graphics.drawq(imgBG,logo_quad,32,21)

	drawIcons()

	drawMatrix(matPiano,17,PIANO_OFF_X,PIANO_OFF_Y)
	drawMatrix(matBass,25,BASS_OFF_X,BASS_OFF_Y)

	-- draw drum matrices
	love.graphics.push()
	love.graphics.setColor(255,255,255,255)
	love.graphics.translate(KICK_OFF_X*CELLW,KICK_OFF_Y*CELLH)
	for x=0,15 do
		if x == play_x and play == true then
			love.graphics.drawq(imgTiles,quad[2+matKick[pat][x]],x*CELLW,0)
			love.graphics.drawq(imgTiles,quad[10+matSnare[pat][x]],x*CELLW,CELLH)
			love.graphics.drawq(imgTiles,quad[26+matHat[pat][x]],x*CELLW,2*CELLH)
			love.graphics.drawq(imgTiles,quad[18+matRide[pat][x]],x*CELLW,3*CELLH)
		else
			love.graphics.drawq(imgTiles,quad[1+matKick[pat][x]],x*CELLW,0)
			love.graphics.drawq(imgTiles,quad[9+matSnare[pat][x]],x*CELLW,CELLH)
			love.graphics.drawq(imgTiles,quad[25+matHat[pat][x]],x*CELLW,2*CELLH)
			love.graphics.drawq(imgTiles,quad[17+matRide[pat][x]],x*CELLW,3*CELLH)
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
	-- draw pattern select buttons
	love.graphics.push()
	love.graphics.translate(PAT_OFF_X*CELLW,PAT_OFF_Y*CELLH)
	for i=0,num_pat-1 do
		if i+1 == pat then
			love.graphics.drawq(imgTiles,quad[2],i*CELLW,0)
			love.graphics.setColor(0,0,0,255)
			love.graphics.print(i+1,i*CELLW+6,4)
			love.graphics.setColor(255,255,255,255)
		else
			love.graphics.drawq(imgTiles,quad[1],i*CELLW,0)
			love.graphics.print(i+1,i*CELLW+6,4)
		end
	end
	if num_pat < MAX_PAT then
		love.graphics.drawq(imgTiles,quad[12],num_pat*CELLW,0)
	end
	love.graphics.pop()
	-- draw hover
	if hover ~= nil then
		drawTextBox(hover[1],hover[2],hover[3])
	end
	-- draw song editor
	if song_scroll == 0 then
		love.graphics.drawq(imgTiles,quad[31],(SONG_OFF_X-1)*CELLW,SONG_OFF_Y*CELLH)
	else
		love.graphics.drawq(imgTiles,quad[13],(SONG_OFF_X-1)*CELLW,SONG_OFF_Y*CELLH)
	end
	for i=0,30 do
		if (song_focus or state == 2) and i+song_scroll == song_sel then
			love.graphics.drawq(imgTiles,quad[22],(i+SONG_OFF_X)*CELLW,SONG_OFF_Y*CELLH)
		else
			if i+song_scroll < song_len then
				if state == 2 then
					love.graphics.drawq(imgTiles,quad[21],(i+SONG_OFF_X)*CELLW,SONG_OFF_Y*CELLH)
				else
					love.graphics.drawq(imgTiles,quad[20],(i+SONG_OFF_X)*CELLW,SONG_OFF_Y*CELLH)
				end
			else
				love.graphics.drawq(imgTiles,quad[23],(i+SONG_OFF_X)*CELLW,SONG_OFF_Y*CELLH)
			end
		end
	end
	if song_scroll < song_sel then
		love.graphics.drawq(imgTiles,quad[14],(SONG_OFF_X+31)*CELLW,SONG_OFF_Y*CELLH)
	else
		love.graphics.drawq(imgTiles,quad[39],(SONG_OFF_X+31)*CELLW,SONG_OFF_Y*CELLH)
	end
	love.graphics.setColor(0,0,0,255)
	for i=0,30 do
		if i+song_scroll < song_len then
			love.graphics.print(song[i+song_scroll],(SONG_OFF_X+i)*CELLW+6,SONG_OFF_Y*CELLH+4)
		end
	end
end

function drawSave()
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",175,207,242,50)
	love.graphics.setColor(4,31,85,255)
	love.graphics.rectangle("fill",176,208,240,48)
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq(imgTiles,quad[28],192,224)
	for i = 1,10 do
		love.graphics.drawq(imgTiles,quad[29],192+i*CELLW,224)
	end
	love.graphics.drawq(imgTiles,quad[30],368,224)
	love.graphics.drawq(imgTiles,quad[15],384,224)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Export to file:",185,213)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(filename,196,228)
	love.graphics.print("|",193+font:getWidth(filename:sub(1,caret)),228)
end

function drawTextBox(text,x,y)
	local w = font:getWidth(text)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",x-4,y-4,w+8,16)
	love.graphics.setColor(4,31,85,255)
	love.graphics.rectangle("fill",x-3,y-3,w+6,14)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(text,x,y)
end

function drawIcons()
	love.graphics.drawq(imgTiles,quad[0],CELLW,PIANO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[8],CELLW,KICK_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[16],CELLW,SNARE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[24],CELLW,HAT_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[32],CELLW,RIDE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[40],(BASS_OFF_X-1)*CELLW,BASS_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[48],(TEMPO_OFF_X-1)*CELLW,TEMPO_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[56],(SCALE_OFF_X-1)*CELLW,SCALE_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[33],(PAT_OFF_X-1)*CELLW,PAT_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[41],(SONG_OFF_X-2)*CELLW,SONG_OFF_Y*CELLH)
	love.graphics.drawq(imgTiles,quad[15],(SONG_OFF_X+32)*CELLW,SONG_OFF_Y*CELLH)
end

function drawMatrix(matrix,tile,xoffset,yoffset)
	love.graphics.push()
	love.graphics.translate(xoffset*CELLW,yoffset*CELLH)
	for iy=0,15 do
		for ix=0,15 do
			if ix == play_x and play == true then
				love.graphics.drawq(imgTiles,quad[tile+1+matrix[pat][ix+iy*16]],ix*CELLW,iy*CELLH)
			else
				love.graphics.drawq(imgTiles,quad[tile+matrix[pat][ix+iy*16]],ix*CELLW,iy*CELLH)
			end
		end
	end
	love.graphics.pop()
end
