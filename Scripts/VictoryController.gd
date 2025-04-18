extends CanvasLayer
	
var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
@export var canPlay : bool = false

#onready var levelSelect = load("res://Scenes/Menus/LevelSelectRoot.tscn")
@onready var existingLevel = get_node("/root/LevelSelectRoot")

@onready var world = get_node("/root/World")

func _on_Button_pressed():
	#var level = levelSelect.instance()
	#get_tree().get_root().add_child(level)
	#queue_free()
	get_tree().paused = false
	
	#Despawn current level
	world.queue_free()
	
	existingLevel.show()
	
	if existingLevel.curLevel == 0:
		existingLevel.finishedAnt = true
	elif existingLevel.curLevel == 1:
		existingLevel.finishedBeetle = true
	elif existingLevel.curLevel == 1:
		existingLevel.finishedBee = true
	else:
		existingLevel.finishedSpider = true	
	
	existingLevel.save_game()
	existingLevel.ShowProgress()
	
	play_sound(click, true)
	#Quit game for build purposes
	#get_tree().quit()
	
	hide()
	
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
