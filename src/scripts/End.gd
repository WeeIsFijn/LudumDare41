extends Node2D

signal clicked

var is_shown = false

func show_end():
	is_shown = true
	#$AnimationPlayer.play("slidein")
	show()
	
func _input(event):
	if is_shown and event.is_action_pressed("ui_click"):
		is_shown = false
		hide()
		emit_signal("clicked")