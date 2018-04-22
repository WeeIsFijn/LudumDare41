extends Node

signal lap_will_start
signal lap_did_start
signal lap_did_stop

onready var LapTimer = $LapTimer
onready var StartCountdownTimer = $StartCountdownTimer

var startCountdownSecondsLeft = 3

func _ready():
	StartCountdownTimer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	startCountdownSecondsLeft -= 1
	if startCountdownSecondsLeft == 0:
		start_lap()
	else:
		emit_signal("lap_will_start", startCountdownSecondsLeft)
		StartCountdownTimer.start()

func countdown_and_start_lap():
	LapTimer.reset()
	startCountdownSecondsLeft = 3
	emit_signal("lap_will_start", startCountdownSecondsLeft)
	StartCountdownTimer.start()

func start_lap():
	LapTimer.start()
	emit_signal("lap_did_start")

func stop_lap():
	LapTimer.stop()
	emit_signal("lap_did_stop")

