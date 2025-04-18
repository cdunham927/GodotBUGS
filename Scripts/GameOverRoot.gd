extends CanvasLayer
	
var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
var canPlay : bool = false

func _on_Button_pressed():
	play_sound(click, true)
	get_tree().reload_current_scene()
	get_tree().paused = false
	hide()

func _on_Button2_pressed():
	play_sound(click, true)
	get_tree().quit()

@export var pitchLow: float = 0.8
@export var pitchHigh: float = 1.3
func play_sound(snd, pitched = false):
	if !canPlay:
		canPlay = true
		return
	if pitched:
		$AudioStreamPlayer.pitch_scale = randf_range(pitchLow, pitchHigh)
	$AudioStreamPlayer.stream = snd
	$AudioStreamPlayer.play()

func _on_ContinueButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_SaveAndQuitButton_focus_entered():
	play_sound(menuSwitch, true)
