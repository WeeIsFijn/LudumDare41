extends Node

var started
var value

func _ready():
	started = false
	value = 0.0

func start():
	started = true

func stop():
	started = false

func reset():
	value = 0.0

func _process(delta):
	if started:
		value += delta

func getSeconds():
	return floor(value)

func getMilliseconds():
	return floor((value - floor(value))*100)