extends CanvasLayer

func _on_streak_change(streak):
	$"streak-label".set_text("Streak: " + str(streak))
	
func view_announcement(an):
	$"Node2D/announcement".set_text(an)
	$"AnimationPlayer".play("announcement")
	
func _on_arrow_miss():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Dance Move Miss!")
	
func _on_wrong_input():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Woops!")