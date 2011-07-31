function writeToMidi()
	local MIDI = require("MIDI")

	local beat = math.floor(wait*60)
	local events = {}
	table.insert(events,{'patch_change',0,1,1})
	table.insert(events,{'patch_change',0,2,35})
	-- add piano and bass
	for pat = 1,num_pat do
		for ix = 0,15 do
			for iy = 0,15 do
				local midinote = #freq-scale[cur_scale][iy+1]+36
				local delta = (pat-1)*beat*16+ix*beat
				-- piano
				if matPiano[pat][ix+iy*16] == 1 then
					local e = {'note',delta,beat,1,midinote,96}
					table.insert(events,e)
				end
				-- bass
				if matBass[pat][ix+iy*16] == 1 then
					local e = {'note',delta,beat,2,midinote-12,96}
					table.insert(events,e)
				end
				-- drums
				if matKick[pat][ix] == 1 then
					table.insert(events,{'note',delta,beat,9,47,127})
				end
				if matSnare[pat][ix] == 1 then
					table.insert(events,{'note',delta,beat,9,40,100})
				end
				if matHat[pat][ix] == 1 then
					table.insert(events,{'note',delta,beat,9,42,127})
				end
				if matRide[pat][ix] == 1 then
					table.insert(events,{'note',delta,beat,9,51,127})
				end
			end
		end
	end
	local score = {32,events}
	local mymidi = MIDI.score2midi(score)
	local file = assert(io.open('export.mid','w'))
	file:write(mymidi)
	file:close()
end
