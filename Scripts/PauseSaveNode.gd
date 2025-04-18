extends Node

@export var masterVol: float
@export var soundVol: float
@export var musicVol: float

var savePath = "user://options.dat"
@onready var par = get_node("/root/World/PauseRoot")

func _init():
	load_game()

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
			
			#par.LoadSettings(self)
			
			save_game.close()
			
