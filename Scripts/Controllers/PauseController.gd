extends CanvasLayer
	
var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
var canPlay : bool = false

@onready var masterVolSlider = $Control/CenterContainer/VBoxContainer/VBoxContainer/MasterVolumeParent/MasterVolumeSlider
@onready var musicVolSlider = $Control/CenterContainer/VBoxContainer/VBoxContainer/MusicVolumeParent/MusicVolumeSlider
@onready var soundVolSlider = $Control/CenterContainer/VBoxContainer/VBoxContainer/SoundVolumeParent/SoundVolumeSlider

@export var masterVol: float
@export var soundVol: float
@export var musicVol: float

var savePath = "user://options.dat"

func _ready():
	load_game()

func LoadSettings():
	masterVolSlider.value = masterVol
	musicVolSlider.value = musicVol
	soundVolSlider.value = soundVol

	set_bus_volume(0, masterVol)
	set_bus_volume(1, musicVol)
	set_bus_volume(2, soundVol)
			
	#print("Master volume: ", masterVol.value)
	#print("Music volume: ", musicVol.value)
	#print("Sound volume: ", soundVol.value)

func _on_Button_pressed():
	play_sound(click, true)
	get_tree().paused = false
	hide()

func _on_Button2_pressed():
	play_sound(click, true)
	save_game()
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

func _on_MasterVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/MasterVolumeParent/Label.text = "Master - " + str(value * 100) + "%"
	set_bus_volume(0, value)
	masterVol = value

func _on_MusicVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/MusicVolumeParent/Label.text = "Music - " + str(value * 100) + "%"
	set_bus_volume(1, value)
	musicVol = value

func _on_SoundVolumeSlider_value_changed(value):
	$Control/CenterContainer/VBoxContainer/VBoxContainer/SoundVolumeParent/Label.text = "Sound - " + str(value * 100) + "%"
	set_bus_volume(2, value)
	soundVol = value
	
func set_bus_volume(bus_index: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)


func _on_Timer_timeout():
	#LoadSettings()
	pass
	
func save_game():
	var data = {
		"masterVol" : masterVol,
		"musicVol" : musicVol,
		"soundVol" : soundVol,
	}
	
	var save_game = File.new()
	var error = save_game.open(savePath, File.WRITE)
	if error == OK:
		save_game.store_var(data)
		save_game.close()
	
func load_game():
	var save_game = File.new()
	if save_game.file_exists(savePath):
		var error = save_game.open(savePath, File.READ)
		if error == OK:
			var player_data = save_game.get_var()
			
			masterVol = player_data["masterVol"]
			musicVol = player_data["musicVol"]
			soundVol = player_data["soundVol"]
			
			#print("Master volume: ", masterVol)
			#print("Music volume: ", musicVol)
			#print("Sound volume: ", soundVol)
			
			LoadSettings()
			
			save_game.close()
