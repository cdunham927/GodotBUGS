extends CanvasLayer

#onready var menu = load("res://menu.tscn").instance()
onready var world = load("res://Scenes/Levels/Overworld.tscn")

var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
export var canPlay : bool = false

func _on_ContinueButton_pressed():
	#Load save file
	
	
	
	
	
	#For now, load main level
	
	#This way hides the current scene
	var game = world.instance()
	get_tree().get_root().add_child(game)
	#queue_free()
	hide()
	
	#var game = world.instance()
	#get_tree().get_root().add_child(game)
	#hide ()
	play_sound(click, true)

func _on_NewGameButton_pressed():
	#Replace save data
	
	
	
	
	play_sound(click, true)

func _on_OptionsButton_pressed():
	#Open options menu
	
	
	
	
	play_sound(click, true)
	pass # Replace with function body.

#func _ready():
#	add_child(menu)

#func _on_remove_child_button_pressed():
#	remove_child(menu)
	
#func _on_add_child_button_pressed():
#	add_child(menu)



func _on_QuitButton_pressed():
	#Save data?
	
	
	play_sound(click, true)
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

func _on_NewGameButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_OptionsButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_QuitButton_focus_entered():
	play_sound(menuSwitch, true)
