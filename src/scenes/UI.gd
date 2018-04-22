extends CanvasLayer

func _on_streak_change(streak):
	$"streak-label".set_text("Streak: " + str(streak))
	
func view_announcement(an, color = Color(0, 0, 0)):
	$"Node2D/announcement".set_text(an)
	$"Node2D/announcement".add_color_override("font_color", color)
	$"AnimationPlayer".play("announcement")
	
func _on_arrow_miss():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Dance Move Miss!", Color(1, 0, 0))
	
func _on_wrong_input():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Woops!", Color(1, 0, 0))
		
func _on_player_powerup(power):
	if power != 1:
		view_announcement("Dance Streak Multiplier: " + str(power) + "!!!", Color(0, 1, 0))
	
	$"power-label".set_text("Dance Streak Multiplier: " + str(power))
	