extends CanvasLayer

#onready var menu = load("res://menu.tscn").instance()
@onready var world = load("res://Scenes/Levels/Overworld.tscn")
@onready var antLevel = load("res://Scenes/Levels/MainLevels/AntLevel.tscn")
@onready var beetleLevel = load("res://Scenes/Levels/MainLevels/BeetleLevel.tscn")
@onready var beeLevel = load("res://Scenes/Levels/MainLevels/BeeLevel.tscn")
@onready var spiderLevel = load("res://Scenes/Levels/MainLevels/SpiderLevel.tscn")

var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
@export var canPlay : bool = false

@export var finishedAnt: bool
@export var finishedBee: bool
@export var finishedBeetle: bool
@export var finishedSpider: bool

var savePath = "user://savegame.dat"
@onready var par = get_node("/root/World/PauseRoot")

@onready var antText = $MenuParent/HBoxContainer/BG2/MenuOptions/ContinueButton
@onready var beeText = $MenuParent/HBoxContainer/BG2/MenuOptions/OptionsButton
@onready var beetleText = $MenuParent/HBoxContainer/BG2/MenuOptions/NewGameButton
@onready var spiderText = $MenuParent/HBoxContainer/BG2/MenuOptions/QuitButton
@onready var antFinishText = $MenuParent/HBoxContainer/BG2/MenuOptions/ContinueButton/RichTextLabel
@onready var beeFinishText = $MenuParent/HBoxContainer/BG2/MenuOptions/OptionsButton/RichTextLabel3
@onready var beetleFinishText = $MenuParent/HBoxContainer/BG2/MenuOptions/NewGameButton/RichTextLabel2
@onready var spiderFinishText = $MenuParent/HBoxContainer/BG2/MenuOptions/QuitButton/RichTextLabel4

var curLevel = 0

func ShowProgress():
	if finishedAnt:
		antText.text = ""
		antFinishText.show()
	else:
		antText.text = "Ants"
		antFinishText.hide()
	if finishedBeetle:
		beetleText.text = ""
		beetleFinishText.show()
	else:
		beetleText.text = "Beetles"
		beetleFinishText.hide()
	if finishedBee:
		beeText.text = ""
		beeFinishText.show()
	else:
		beeText.text = "Bees"
		beeFinishText.hide()
	if finishedSpider:
		spiderText.text = ""
		spiderFinishText.show()
	else:
		spiderText.text = "Spiders"
		spiderFinishText.hide()

func _on_ContinueButton_pressed():
	#Ant Level
	var game = antLevel.instantiate()
	curLevel = 0
	get_tree().get_root().add_child(game)
	#queue_free()
	hide()
	
	play_sound(click, true)

func _on_NewGameButton_pressed():
	#Beetle Level
	var game = beetleLevel.instantiate()
	curLevel = 1
	get_tree().get_root().add_child(game)
	hide()
	play_sound(click, true)

func _on_OptionsButton_pressed():
	#Bee Level
	var game = beeLevel.instantiate()
	curLevel = 2
	get_tree().get_root().add_child(game)
	hide()
	play_sound(click, true)

func _on_QuitButton_pressed():
	#Spider Level
	var game = spiderLevel.instantiate()
	curLevel = 3
	get_tree().get_root().add_child(game)
	#get_parent().save_game()
	hide()
	play_sound(click, true)
	
@export var pitchLow: float = 0.8
@export var pitchHigh: float = 1.3
func play_sound(snd, pitched = false):
	if !canPlay:
		canPlay = true
		return
	if pitched:
		$MenuParent/AudioStreamPlayer.pitch_scale = randf_range(pitchLow, pitchHigh)
	$MenuParent/AudioStreamPlayer.stream = snd
	$MenuParent/AudioStreamPlayer.play()

func _on_ContinueButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_NewGameButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_OptionsButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_QuitButton_focus_entered():
	play_sound(menuSwitch, true)

func _ready():
	load_game()
	ShowProgress()

func save_game():
	var data = {
		"finishedAnt" : finishedAnt,
		"finishedBee" : finishedBee,
		"finishedBeetle" : finishedBeetle,
		"finishedSpider" : finishedSpider,
	}
	
	var save_game = File.new()
	var error = save_game.open(savePath, File.WRITE)
	if error == OK:
		save_game.store_var(data)
		
		#print(save_game)
		
		save_game.close()
		

func delete_game():
	var data = {
		"finishedAnt" : false,
		"finishedBee" : false,
		"finishedBeetle" : false,
		"finishedSpider" : false,
	}
	finishedAnt = false
	finishedBee = false
	finishedBeetle = false
	finishedSpider = false
	
	var save_game = File.new()
	var error = save_game.open(savePath, File.WRITE)
	if error == OK:
		save_game.store_var(data)
		
		print(save_game)
		
		save_game.close()

func load_game():
	var save_game = File.new()
	if save_game.file_exists(savePath):
		var error = save_game.open(savePath, File.READ)
		if error == OK:
			var player_data = save_game.get_var()
			
			finishedAnt = player_data["finishedAnt"]
			finishedBee = player_data["finishedBee"]
			finishedBeetle = player_data["finishedBeetle"]
			finishedSpider = player_data["finishedSpider"]
		
			#par.LoadSettings(self)
			
			save_game.close()
