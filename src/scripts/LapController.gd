extends Node

signal lap_will_start
signal lap_did_start
signal lap_did_stop
signal lap_finished(lap_num)
signal track_finished

onready var LapTimer = $LapTimer
onready var StartCountdownTimer = $StartCountdownTimer
onready var Finish = $Finish 
onready var Checkpoint = $Checkpoint

var startCountdownSecondsLeft = 3
const NUM_LAPS = 3
var num_laps_done = 0
var can_finish = false

var total_time = 0

func _ready():
	StartCountdownTimer.connect("timeout", self, "_on_timeout")
	
	Finish.connect("area_entered", self, "_on_finish_crossed")
	Checkpoint.connect("area_entered", self, "_on_checkpoint_crossed")
	
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
	can_finish = false
	emit_signal("lap_did_start")

func stop_lap():
	LapTimer.stop()
	emit_signal("lap_did_stop")
	
func reset():
	num_laps_done = 0

func _on_finish_crossed(body):
	if can_finish:
		can_finish = false
		num_laps_done += 1
		
		total_time += LapTimer.value
		
		if num_laps_done >= 1:
			emit_signal("track_finished")
		else:
			emit_signal("lap_finished", num_laps_done + 1)
	
func _on_checkpoint_crossed(body):
	can_finish = true
	
func _on_player_death():
	can_finish = false