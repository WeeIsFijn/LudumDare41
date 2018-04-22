extends Node2D

onready var car = $CarRoot
onready var dance = $"CarRoot/Dance-root"
onready var ui = $"CarRoot/UI"
onready var LapController = $LapController

onready var player = $"CarRoot"
onready var powerup_manager = $"PowerUpManager"
onready var camera = $"CarRoot/Camera2D"

onready var spawn = $"Spawn"

func _ready():
	dance.connect("streak_change", ui, "_on_streak_change")
	dance.connect("wrong_input", ui, "_on_wrong_input")
	dance.connect("missed_arrow", ui, "_on_arrow_miss")
	dance.connect("streak_change", powerup_manager, "_on_dance_arrow_streak_change")
	
	LapController.connect("lap_will_start", ui, "_on_lap_will_start")
	LapController.connect("lap_did_start", ui, "_on_lap_did_start")
	LapController.connect("lap_did_stop", ui, "_on_lap_did_stop")
	LapController.connect("lap_did_start", self, "_on_lap_did_start")
	
	powerup_manager.connect("powerup", ui, "_on_player_powerup")
	powerup_manager.connect("powerup", player, "_on_powerup")
	powerup_manager.connect("powerup", camera, "_on_player_powerup")
	
	player.connect("died", self, "reset")

	reset()
	LapController.countdown_and_start_lap()
	

func _on_lap_did_start():
	pass

func reset():
	player.set_position(spawn.position)
	player.set_rotation(spawn.rotation)
	ui._on_streak_change(0)
	powerup_manager._on_dance_arrow_streak_change(0)
	dance.streak = 0
