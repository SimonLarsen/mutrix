function writeToMidi()
	local MIDI = require("MIDI")

	local tempo = wait*1000000
	local tpb = 96
	local events = {}
	table.insert(events,{'patch_change',0,1,MIDI_PIANO})
	table.insert(events,{'patch_change',0,2,MIDI_BASS})
	table.insert(events,{'set_tempo',0,tempo})
	-- add piano and bass
	for i = 0,song_len-1 do
		local pat = song[i]
		for ix = 0,15 do
			for iy = 0,15 do
				local midinote = #freq-scale[cur_scale][iy+1]+36
				local delta = i*tpb*16+ix*tpb
				-- piano
				if matPiano[pat][ix+iy*16] == 1 then
					local e = {'note',delta,tpb,1,midinote,96}
					table.insert(events,e)
				end
				-- bass
				if matBass[pat][ix+iy*16] == 1 then
					local e = {'note',delta,tpb,2,midinote-12,96}
					table.insert(events,e)
				end
				-- drums
				if matKick[pat][ix] == 1 then
					table.insert(events,{'note',delta,tpb,9,MIDI_KICK,96})
				end
				if matSnare[pat][ix] == 1 then
					table.insert(events,{'note',delta,tpb,9,MIDI_SNARE,96})
				end
				if matHat[pat][ix] == 1 then
					table.insert(events,{'note',delta,tpb,9,MIDI_HAT,96})
				end
				if matRide[pat][ix] == 1 then
					table.insert(events,{'note',delta,tpb,9,MIDI_RIDE,96})
				end
			end
		end
	end
	local score = {tpb,events}
	local mymidi = MIDI.score2midi(score)
	local file = assert(io.open(filename,'w'))
	file:write(mymidi)
	file:close()
end
