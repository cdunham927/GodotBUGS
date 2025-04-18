extends CanvasLayer

#onready var menu = load("res://menu.tscn").instance()
@onready var world = load("res://Scenes/Menus/LevelSelectRoot.tscn")

var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
@export var canPlay : bool = false

@onready var continueButton = $Control/CenterContainer/HBoxContainer/VBoxContainer2/MenuOptions/ContinueButton

func _ready():
	#Activate continue button if we have save data
	load_game()

func _on_ContinueButton_pressed():
	#For now, load level select
	#This way hides the current scene
	var game = world.instantiate()
	get_tree().get_root().add_child(game)
	#queue_free()
	hide()
	
	#var game = world.instance()
	#get_tree().get_root().add_child(game)
	#hide ()
	play_sound(click, true)

func _on_NewGameButton_pressed():
	#Replace save data
	var game = world.instantiate()
	game.delete_game()
	get_tree().get_root().add_child(game)
	#queue_free()
	hide()	
	
	play_sound(click, true)

func _on_OptionsButton_pressed():
	#Open options menu
	
	
	
	
	play_sound(click, true)

func _on_QuitButton_pressed():
	#Save data?
	
	
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
	
var savePath = "user://savegame.dat"
var hasSave = false

func load_game():
	var save_game = File.new()
	if save_game.file_exists(savePath):
		var error = save_game.open(savePath, File.READ)
		if error == OK:
			var player_data = save_game.get_var()
			
			#Check if we have save data
			if (player_data["finishedAnt"] == true or player_data["finishedBee"] == true
			or player_data["finishedBeetle"] == true or player_data["finishedSpider"] == true):
				hasSave = true
		
			if hasSave:
				continueButton.disabled = false
			else:
				continueButton.disabled = true
			
			save_game.close()


func _on_ContinueButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_NewGameButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_OptionsButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_QuitButton_focus_entered():
	play_sound(menuSwitch, true)
