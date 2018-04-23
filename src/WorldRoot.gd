extends Node2D

onready var car = $CarRoot
onready var dance = $"CarRoot/Dance-root"
onready var ui = $"CarRoot/UI"
onready var LapController = $LapController

onready var player = $"CarRoot"
onready var powerup_manager = $"PowerUpManager"
onready var camera = $"CarRoot/Camera2D"

onready var spawn = $"Track_container/Track1/Spawn"

onready var next_track_timer = $"Next_track_timer"

onready var music_player = $"MusicPlayer"

onready var popup = $"CarRoot/UI/Popup"
onready var tutorial = $"CarRoot/UI/Tutorial"
onready var end = $"CarRoot/UI/End"

var current_track = 1
var loaded_track = 0
onready var current_track_node = $"Track_container/Track1"

var tracks = [
	preload("res://scenes/tracks/track00.tscn"),
	preload("res://scenes/tracks/track01.tscn"), 
	preload("res://scenes/tracks/track02.tscn"),
	preload("res://scenes/tracks/track03.tscn"),
	preload("res://scenes/tracks/track04.tscn")
]

func _ready():
	dance.connect("streak_change", ui, "_on_streak_change")
	dance.connect("wrong_input", ui, "_on_wrong_input")
	dance.connect("missed_arrow", ui, "_on_arrow_miss")
	dance.connect("streak_change", powerup_manager, "_on_dance_arrow_streak_change")
	
	LapController.connect("lap_finished", ui, "_on_lap_finished")
	LapController.connect("track_finished", ui, "_on_track_finished")
	LapController.connect("lap_will_start", ui, "_on_lap_will_start")
	LapController.connect("lap_did_start", ui, "_on_lap_did_start")
	LapController.connect("lap_did_stop", ui, "_on_lap_did_stop")
	
	LapController.connect("lap_did_start", self, "_on_lap_did_start")
	LapController.connect("track_finished", self, "_on_track_finished")
	
	LapController.connect("track_finished", player, "_on_track_finish")
	
	powerup_manager.connect("powerup", ui, "_on_player_powerup")
	powerup_manager.connect("powerup", player, "_on_powerup")
	powerup_manager.connect("powerup", camera, "_on_player_powerup")
	
	player.connect("died", self, "_on_player_died")
	player.connect("died", dance, "reset")
	player.connect("died", LapController, "_on_player_death")
	
	popup.connect("clicked", self, "_on_popup_clicked")
	tutorial.connect("clicked", self, "_on_tutorial_clicked")
	end.connect("clicked", self, "_on_end_clicked")

	#reset()
	set_positions()
	
func _on_end_clicked():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	
func _on_tutorial_clicked():
	reset()
	
func _on_popup_clicked():
	if current_track <= 5:
		load_track(current_track)
	else:
		end.show_end()
	
func load_track(track_number):
	current_track_node.queue_free()
	var track = tracks[track_number - 1].instance()
	track.set_name("Track" + str(track_number))
	track.connect("tree_entered", self, "set_positions")
	current_track_node = track
	$Track_container.add_child(track)
	
	ui.reset()
	LapController.reset()
	
	music_player.next_song()

	reset()
	LapController.countdown_and_start_lap()
	
func set_positions():
	spawn = get_node("Track_container/Track" + str(current_track) + "/Spawn")
	player.set_position(spawn.position)
	player.set_rotation(spawn.rotation)
	LapController.Finish.set_position(get_node("Track_container/Track" + str(current_track) + "/Finish").position)
	LapController.Checkpoint.set_position(get_node("Track_container/Track" + str(current_track) + "/Checkpoint").position)

func _on_lap_did_start():
	car.start_engine()
	dance.start()
	
	music_player.up_volume()
	
func _on_track_finished():
	car.stop_engine()
	current_track += 1
	
	popup.show_popup(LapController.lap_times, LapController.total_time)
	
	dance.stop()
	music_player.lower_volume()
	
func _on_player_died():
	reset()
	set_positions()

func reset():
	car.engine_running = false
	ui._on_streak_change(0)
	powerup_manager._on_dance_arrow_streak_change(0)
	dance.streak = 0
	LapController.stop_lap()
	LapController.countdown_and_start_lap()

func _process(delta):
	if Input.is_action_just_released("ui_back"):
		get_tree().change_scene("res://scenes/MainMenu.tscn")