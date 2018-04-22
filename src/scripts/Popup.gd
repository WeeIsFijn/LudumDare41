extends Node2D

signal clicked

func show_popup(lap_times, total_time):
	$"lap-time1".set_text( str(lap_times[0]) )
	$"lap-time2".set_text( str(lap_times[1]) )
	$"lap-time3".set_text( str(lap_times[2]) )
	
	$"total-time".set_text( str(total_time) )
	
	show()
	
func _input(event):
	if event.is_action_pressed("ui_click"):
		hide()
		emit_signal("clicked")