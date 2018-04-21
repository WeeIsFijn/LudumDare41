extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const arrow_class = preload("arrow.tscn")

signal missed_arrow
signal wrong_input

func _ready():
	$"arrow_timer".connect("timeout", self, "_on_arrowtimer_timeout")
	
func proces_key_stroke(action):
	var overlapping_areas = $"Target area".get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("arrow") and area.get_direction() == action:
			area.hit()

func _input(event):
	if Input.is_action_just_pressed("ui_right"):
		proces_key_stroke("ui_right")
	elif Input.is_action_just_pressed("ui_left"):
		proces_key_stroke("ui_left")
	elif Input.is_action_just_pressed("ui_up"):
		proces_key_stroke("ui_up")
	elif Input.is_action_just_pressed("ui_down"):
		proces_key_stroke("ui_down")
	else:
		emit_signal("wrong_input")
		
		
func _on_arrowtimer_timeout():
	var new_arrow = arrow_class.instance()
	
	# Initiate arrow
	new_arrow.init(randi()%4, Vector2(20,20))
	new_arrow.connect("missed_arrow", self, "_on_arrow_missed_arrow")
	
	add_child(new_arrow)
	
func _on_arrow_missed_arrow():
	emit_signal("missed_arrow")