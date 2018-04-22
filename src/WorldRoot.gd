extends Node2D

onready var dance = $"CarRoot/Dance-root"
onready var ui = $"CarRoot/UI"

onready var player = $"CarRoot"
onready var powerup_manager = $"PowerUpManager"
onready var camera = $"CarRoot/Camera2D"

onready var spawn = $"Spawn"

func _ready():
	dance.connect("streak_change", ui, "_on_streak_change")
	dance.connect("wrong_input", ui, "_on_wrong_input")
	dance.connect("missed_arrow", ui, "_on_arrow_miss")
	
	dance.connect("streak_change", powerup_manager, "_on_dance_arrow_streak_change")
	
	powerup_manager.connect("powerup", ui, "_on_player_powerup")
	powerup_manager.connect("powerup", player, "_on_powerup")
	powerup_manager.connect("powerup", camera, "_on_player_powerup")
	
	player.connect("died", self, "reset")

	reset()

func reset():
	player.set_position(spawn.position)
	player.set_rotation(spawn.rotation)
	ui._on_streak_change(0)
	powerup_manager._on_dance_arrow_streak_change(0)
	dance.streak = 0