extends Node2D

signal clicked

var is_shown = false

func show_popup(lap_times, total_time, lap):
	$"tracks-finished-content".set_text( str(lap) )
	
	$"lap-time1".set_text( str(lap_times[0]) )
	$"lap-time2".set_text( str(lap_times[1]) )
	$"lap-time3".set_text( str(lap_times[2]) )
	
	$"total-time".set_text( str(total_time) )
	
	is_shown = true
	
	show()
	
	#$AnimationPlayer.play("slidein")
	
func _input(event):
	if is_shown and event.is_action_pressed("ui_click"):
		is_shown = false
		hide()
		emit_signal("clicked")