function updatePlayer(dt)
	time = time+dt
	hover = nil
	if time > wait and play == true then
		time = time%wait
		play_x = play_x+1
		if play_x == 16 then
			play_x = 0
			if play_song then
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
