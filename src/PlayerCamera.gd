extends Camera2D

const standard_zoom = 2.5

func _process(delta):
	align()

func _on_player_powerup(power):
	if power != 1 or zoom.x != 2.5:
		$"CameraAnimation".play("Zoom" + str(power))