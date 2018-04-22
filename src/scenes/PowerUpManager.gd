extends Node

signal powerup(power)

var power = 0
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
	elif streak == state[power]["next"]:
		power += 1
		emit_signal("powerup", state[power]["multiplier"])