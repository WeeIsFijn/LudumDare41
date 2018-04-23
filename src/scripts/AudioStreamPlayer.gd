extends AudioStreamPlayer

var music = []
var current_song = 0

func _ready():
	load_music("assets/music/Soulbringer_-_Neurometabolic_stimulation.ogg")
	load_music("assets/music/Soulbringer_-_Corvalolum.ogg")
	load_music("assets/music/Soulbringer_-_Double_Psycore.ogg")
	load_music("assets/music/Soulbringer_-_End_of_the_universe.ogg")
	load_music("assets/music/Soulbringer_-_Space_Blockbuster.ogg")
	load_music("assets/music/Soulbringer_-_Stupid_melodies.ogg")
	
	stream = music[current_song]
	play()
	lower_volume()
	
func load_music(input_file):
	var song = load(input_file)
	song.set_loop(true)
	music.append(song)

func next_song():
	current_song += 1
	stream = music[current_song]
	play()
	
func lower_volume():
	volume_db = -3
	
func up_volume():
	volume_db = 2