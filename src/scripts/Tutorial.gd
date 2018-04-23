extends Node2D

signal clicked

var is_shown = true

func _ready():
	#$AnimationPlayer.play("slidein")
	pass
	
func _input(event):
	if is_shown and event.is_action_pressed("ui_click"):
		is_shown = false
		hide()
		emit_signal("clicked")