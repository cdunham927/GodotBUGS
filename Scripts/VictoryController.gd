extends CanvasLayer
	
var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
export var canPlay : bool = false

func _on_Button_pressed():
	#Load overworld
	
	
	play_sound(click, true)
	#Quit game for build purposes
	get_tree().quit()
	
export(float) var pitchLow = 0.8
export(float) var pitchHigh = 1.3
func play_sound(snd, pitched = false):
	if !canPlay:
		canPlay = true
		return
	if pitched:
		$AudioStreamPlayer.pitch_scale = rand_range(pitchLow, pitchHigh)
	$AudioStreamPlayer.stream = snd
	$AudioStreamPlayer.play()


func _on_ContinueButton_focus_entered():
	play_sound(menuSwitch, true)
