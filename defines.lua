require("freq")

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

bgcolor = {54,110,212}

scale = {}
-- D pentatonic major
scale[1] = {"a5","fs5","e5","d5","b4","a4","fs4","e4","d4","b3","a3","fs3","e3","d3","b2","a2"}
-- D pentatonic minor
scale[2] = {"d5","c5","a4","g4","f4","d4","c4","a3","g3","f3","d3","c3","a2","g2","f2","d2"}
-- C major
scale[3] = {"c5","b4","a4","g4","f4","e4","d4","c4","b3","a3","g3","f3","e3","d3","c3","b2"}
-- D blues minor
scale[4] = {"d5","c5","a4","g4","e4","ds4","d4","c4","a3","g3","e3","ds3","d3","c3","a2","g2"}
-- chromatic
scale[5] = {"gs4","g4","fs4","f4","e4","ds4","d4","cs4","c4","b3","as3","a3","gs3","g3","fs3","f3"}

scale_name = {
	"D Pent. Major",
	"D Pent. Minor",
	"C Major",
	"Blues major",
	"Chromatic"
}

MIN_TEMPO = 0.5 
MAX_TEMPO = 0.04
tempo = {}
for i=0,15 do
	tempo[i] = MIN_TEMPO - i*((MIN_TEMPO-MAX_TEMPO)/16)
end
