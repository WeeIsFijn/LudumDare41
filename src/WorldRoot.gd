extends Node2D

onready var car = $CarRoot
onready var dance = $"CarRoot/Dance-root"
onready var ui = $"CarRoot/UI"
onready var LapController = $LapController

func _ready():
	dance.connect("streak_change", ui, "_on_streak_change")
	dance.connect("wrong_input", ui, "_on_wrong_input")
	dance.connect("missed_arrow", ui, "_on_arrow_miss")
	
	LapController.connect("lap_will_start", ui, "_on_lap_will_start")
	LapController.connect("lap_did_start", ui, "_on_lap_did_start")
	LapController.connect("lap_did_stop", ui, "_on_lap_did_stop")
	
	LapController.connect("lap_did_start", self, "_on_lap_did_start")
	
	LapController.countdown_and_start_lap()
	

func _on_lap_did_start():
	