extends Node

@export var masterVol: float = 1.0
@export var soundVol: float = 1.0
@export var musicVol: float = 1.0
@export var finishedAnt: bool = false
@export var finishedBee: bool = false
@export var finishedBeetle: bool = false
@export var finishedSpider: bool = false

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"masterVol" : masterVol,
		"musicVol" : musicVol,
		"soundVol" : soundVol,
		"finishedAnt" : finishedAnt,
		"finishedBee" : finishedBee,
		"finishedBeetle" : finishedBeetle,
		"finishedSpider" : finishedSpider,
	}
	return save_dict
