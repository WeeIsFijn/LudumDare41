extends CanvasLayer

onready var lapTimer = $LapTimer

func _on_streak_change(streak):
	$"streak-label-content".set_text(str(streak))
	
func view_announcement(an):
	$"Node2D/announcement".set_text(an)
	$"AnimationPlayer".play("announcement")
	
func _on_arrow_miss():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Dance Move Miss!")
	
func _on_wrong_input():
	if !$"AnimationPlayer".is_playing():
		view_announcement("Woops!")

func _on_lap_will_start(inSeconds):
	view_announcement(str(inSeconds))
	
func _on_lap_did_start():
	view_announcement("GO")
	lapTimer.start()

func _process(delta):
	$"lap-time-label-content".set_text(str(lapTimer.getSeconds()) + ":" + str(lapTimer.getMilliseconds()))