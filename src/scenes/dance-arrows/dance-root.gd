extends Node

const arrow_class = preload("arrow.tscn")

signal missed_arrow
signal wrong_input
signal hit
signal streak_change(streak)

var streak = 0

func _ready():
	$"arrow_timer".connect("timeout", self, "_on_arrowtimer_timeout")
	print(environment.project_resolution.x)
	
func proces_key_stroke(action):
	var overlapping_areas = $"Target area".get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("arrow") and area.get_direction() == action:
			area.hit()
			set_streak(streak + 1)
			emit_signal("hit")
			return true
	
	return false

func _input(event):
	var processed = [false, false]
	if Input.is_action_just_pressed("ui_right"):
		processed = [true, proces_key_stroke("ui_right")]
	elif Input.is_action_just_pressed("ui_left"):
		processed = [true, proces_key_stroke("ui_left")]
	elif Input.is_action_just_pressed("ui_up"):
		processed = [true, proces_key_stroke("ui_up")]
	elif Input.is_action_just_pressed("ui_down"):
		processed = [true, proces_key_stroke("ui_down")]
	
	if processed[0] and not processed[1]:
		emit_signal("wrong_input")
		set_streak(0)
		
func set_streak(st):
	streak = st
	emit_signal("streak_change", streak)
		
func _on_arrowtimer_timeout():
	var new_arrow = arrow_class.instance()
	
	# Initiate arrow
	new_arrow.init(randi()%4, Vector2(-20,30))
	new_arrow.connect("missed_arrow", self, "_on_arrow_missed_arrow")
	
	add_child(new_arrow)
	
func _on_arrow_missed_arrow():
	emit_signal("missed_arrow")
	set_streak(0)