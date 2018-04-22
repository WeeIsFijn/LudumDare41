extends Node

onready var MouseAudio = $MouseAudio
onready var CreditsDialog = $CreditsDialog

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://WorldRoot.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()

func _process(delta):
	if Input.is_action_pressed("ui_back"):
		get_tree().quit()


func _on_NewGameButton_mouse_entered():
	play_mouse_enter_sound() # replace with function body

func play_mouse_enter_sound():
	MouseAudio.play()

func _on_ExitButton_mouse_entered():
	play_mouse_enter_sound()

func _on_CreditsButton_mouse_entered():
	play_mouse_enter_sound()


func _on_CreditsButton_pressed():
	CreditsDialog.popup()
