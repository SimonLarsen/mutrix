CELLW,CELLH = 16,16

PIANO_OFF_X = 2
PIANO_OFF_Y = 4
KICK_OFF_X = 2
KICK_OFF_Y = 21
SNARE_OFF_X = 2
SNARE_OFF_Y = 22
HAT_OFF_X = 2
HAT_OFF_Y = 23
RIDE_OFF_X = 2
RIDE_OFF_Y = 24
BASS_OFF_X = 20
BASS_OFF_Y = 4
TEMPO_OFF_X = 20
TEMPO_OFF_Y = 21
SCALE_OFF_X = 20
SCALE_OFF_Y = 23
PAT_OFF_X = 27
PAT_OFF_Y = 23
SONG_OFF_X = 3
SONG_OFF_Y = 26

MIDI_OFFSET = 38
MIDI_PIANO = 1
MIDI_BASS = 35
MIDI_KICK = 35
MIDI_SNARE = 38
MIDI_HAT = 42
MIDI_RIDE = 51

MAX_PAT = 9

bgcolor = {54,110,212}

scale = {}
-- D pentatonic major
-- scale[1] = {"a5","fs5","e5","d5","b4","a4","fs4","e4","d4","b3","a3","fs3","e3","d3","b2","a2"}
scale[1] = {1,4,6,8,11,13,16,18,20,23,25,28,30,32,35,37}
-- D pentatonic minor
-- scale[2] = {"d5","c5","a4","g4","f4","d4","c4","a3","g3","f3","d3","c3","a2","g2","f2","d2"}
scale[2] = {8,10,13,15,17,20,22,25,27,29,32,34,37,39,41,44}
-- C major
-- scale[3] = {"c5","b4","a4","g4","f4","e4","d4","c4","b3","a3","g3","f3","e3","d3","c3","b2"}
scale[3] = {10,11,13,15,17,18,20,22,23,25,27,29,30,32,34,35}
-- D blues minor
-- scale[4] = {"d5","c5","a4","g4","e4","ds4","d4","c4","a3","g3","e3","ds3","d3","c3","a2","g2"}
scale[4] = {8,10,13,15,18,19,20,22,25,27,30,31,32,34,37,39}
-- chromatic
-- scale[5] = {"gs4","g4","fs4","f4","e4","ds4","d4","cs4","c4","b3","as3","a3","gs3","g3","fs3","f3"}
scale[5] = {14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29}

scale_name = {
	"D Pent. Major",
	"D Pent. Minor",
	"C Major",
	"Blues major",
	"Chromatic"
}

MIN_TEMPO = 0.5 
MAX_TEMPO = 0.04

-- states
-- 1 edit pattern / song
-- 2 play song
-- 3 save midi
