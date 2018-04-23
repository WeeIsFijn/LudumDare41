extends Node2D

func _on_drift(direction):
	_on_drift_stop()
	
	if direction == 0:
		$Particles2D.emitting = true
	else:
		$Particles2D2.emitting = true

func _on_drift_stop():
	$Particles2D.emitting = false
	$Particles2D2.emitting = false