extends Node

@export var finishedAnt: bool
@export var finishedBee: bool
@export var finishedBeetle: bool
@export var finishedSpider: bool

var savePath = "user://savegame.dat"

func _init():
	load_game()

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
			
			print("Finished Ant: ", finishedAnt)
			print("Finished Bee: ", finishedBee)
			print("Finished Beetle: ", finishedBeetle)
			print("Finished Spider: ", finishedSpider)
			
			#par.LoadSettings(self)
			
			save_game.close()
