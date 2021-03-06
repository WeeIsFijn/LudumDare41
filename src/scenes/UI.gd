extends CanvasLayer

onready var lapTimer = $LapTimer
var current_timer = 1

func _on_streak_change(streak):
	$"streak-label-content".set_text(str(streak))
	
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

func _on_lap_will_start(inSeconds):
	lapTimer.stop()
	lapTimer.reset()
	view_announcement(str(inSeconds), Color(1,1,1))
	
func _on_lap_did_start():
	view_announcement("GO", Color(1,1,1))
	lapTimer.start()

func _process(delta):
	get_node("lap-time-label-content-" + str(current_timer)).set_text(str(lapTimer.getSeconds()) + ":" + str(lapTimer.getMilliseconds()))

func _on_player_powerup(power):
	if power != 1:
		view_announcement("Dance Streak Multiplier: " + str(power) + "!!!", Color(0, 1, 0))
	
	$"mult-label-content".set_text(str(power))

func _on_lap_finished(lap_number):
	if current_timer != 3:
		get_node("lap-time-label-content-" + str(current_timer)).set("custom_colors/font_color", Color("ffaced"))
	current_timer = lap_number
	$"lap-label-content".set_text(str(lap_number) + " / 3")
	lapTimer.reset()
	
func _on_track_finished():
	lapTimer.stop()
	view_announcement("FINISHED!!", Color(0, 0, 1))
	
func reset():
	for i in range(1,4):
		get_node("lap-time-label-content-" + str(i)).set_text("0:0")
		get_node("lap-time-label-content-" + str(i)).set("custom_colors/font_color", Color(1,1,1))
	
	_on_lap_finished(1)