function writeToMidi()
	local MIDI = require("MIDI")

	local beat = math.floor(wait*60)
	local events = {}
	table.insert(events,{'patch_change',0,1,1})
	table.insert(events,{'patch_change',0,2,35})
	-- add piano and bass
	for ix = 0,15 do
		for iy = 0,15 do
			local midinote = #freq-scale[cur_scale][iy+1]+36
			-- piano
			if matPiano[ix+iy*16] == 1 then
				local e = {'note',ix*beat,beat,1,midinote,96}
				table.insert(events,e)
			end
			-- bass
			if matBass[ix+iy*16] == 1 then
				local e = {'note',ix*beat,beat,2,midinote-12,96}
				table.insert(events,e)
			end
			-- drums
			if matKick[ix] == 1 then
				table.insert(events,{'note',ix*beat,beat,9,47,127})
			end
			if matSnare[ix] == 1 then
				table.insert(events,{'note',ix*beat,beat,9,40,100})
			end
			if matHat[ix] == 1 then
				table.insert(events,{'note',ix*beat,beat,9,42,127})
			end
			if matRide[ix] == 1 then
				table.insert(events,{'note',ix*beat,beat,9,51,127})
			end
		end
	end
	local score = {32,events}
	local mymidi = MIDI.score2midi(score)
	local file = assert(io.open('export.mid','w'))
	file:write(mymidi)
	file:close()
end
