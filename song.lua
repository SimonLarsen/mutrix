function songMousePressed(mx,my,button)
	if mx >= SONG_OFF_X-1 and mx <= SONG_OFF_X+31 and my == SONG_OFF_Y then
		if mx >= SONG_OFF_X and mx <= SONG_OFF_X+30 then
			song_focus = true
			local ox = mx-SONG_OFF_X
			if ox > song_len then
				song_sel = song_len
			else
				song_sel = ox
			end
		end
	else
		song_focus = false
	end
end

function songKeyPressed(k,unicode)
	if unicode >= 0x31 and unicode <= 0x30 + num_pat then
		song[song_sel] = unicode - 0x30
		if song_sel == song_len then
			song_len = song_len + 1
		end
		song_sel = song_sel + 1
	elseif k == 'right' and song_sel < song_len then
		song_sel = song_sel + 1
	elseif k == 'left' and song_sel > 0 then
		song_sel = song_sel - 1
	elseif k == 'delete' then
		if song_sel < song_len then
			for i=song_sel,song_len-1 do
				song[i] = song[i+1]
			end
			song_len = song_len - 1
			if song_sel > song_len then
				song_sel = song_len
			end
		end
	elseif k == 'backspace' then
		if song_sel > 0 then
			for i=song_sel-1,song_len-1 do
				song[i] = song[i+1]
			end
			song_len = song_len - 1
			song_sel = song_sel - 1
		end
	end
end
