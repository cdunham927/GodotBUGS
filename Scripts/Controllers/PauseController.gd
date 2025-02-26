extends CanvasLayer
	
var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
var canPlay : bool = false

onready var masterVol = $Control/CenterContainer/VBoxContainer/VBoxContainer/MasterVolumeParent/MasterVolumeSlider
onready var musicVol = $Control/CenterContainer/VBoxContainer/VBoxContainer/MusicVolumeParent/MusicVolumeSlider
onready var soundVol = $Control/CenterContainer/VBoxContainer/VBoxContainer/SoundVolumeParent/SoundVolumeSlider

#func _init():
#	LoadSettings()
	
func LoadSettings():
	masterVol.value = Save.masterVol
	musicVol.value = Save.musicVol
	soundVol.value = Save.soundVol

	set_bus_volume(0, Save.masterVol)
	set_bus_volume(1, Save.musicVol)
	set_bus_volume(2, Save.soundVol)

func _on_Button_pressed():
	play_sound(click, true)
	get_tree().paused = false
	hide()

func _on_Button2_pressed():
	play_sound(click, true)
	get_parent().save_game()
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

func _on_SaveAndQuitButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_MasterVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/MasterVolumeParent/Label.text = "Master - " + str(value * 100) + "%"
	set_bus_volume(0, value)

func _on_MusicVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/MusicVolumeParent/Label.text = "Music - " + str(value * 100) + "%"
	set_bus_volume(1, value)

func _on_SoundVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/SoundVolumeParent/Label.text = "Sound - " + str(value * 100) + "%"
	set_bus_volume(2, value)
	
func set_bus_volume(bus_index: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
