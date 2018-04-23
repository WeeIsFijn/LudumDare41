extends Node

signal powerup(power)

onready var BoostAudio = $BoostAudio
onready var LooseBoostAudio = $LooseBoostAudio

var power = 0
var previous_power = 0

var state = {
	0: {
		"next": 5,
		"multiplier": 1
	},
	1: {
		"next": 10,
		"multiplier": 1.2
	},
	2: {
		"next": 20,
		"multiplier": 1.4
	},
	3: {
		"next": 35,
		"multiplier": 1.6
	},
	4: {
		"next": 50,
		"multiplier": 1.8
	},
	5: {
		"next": 100,
		"multiplier": 2
	},
	6: {
		"next": 1000,
		"multiplier": 2.5
	}
}

func _on_dance_arrow_streak_change(streak):
	if streak == 0:
		power = 0
		emit_signal("powerup", state[power]["multiplier"])
		if previous_power > 0:
			LooseBoostAudio.play()
		previous_power = 0
	elif streak == state[power]["next"]:
		previous_power = power
		power += 1
		BoostAudio.play()
		emit_signal("powerup", state[power]["multiplier"])