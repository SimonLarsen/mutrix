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
