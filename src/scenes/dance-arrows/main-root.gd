extends Node

onready var dance = $"Dance-root"
onready var ui = $"UI"

func _ready():
	dance.connect("streak_change", ui, "_on_streak_change")
	dance.connect("wrong_input", ui, "_on_wrong_input")
	dance.connect("missed_arrow", ui, "_on_arrow_miss")
	