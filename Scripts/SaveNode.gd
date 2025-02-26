extends Node

export(float) var masterVol = 1.0
export(float) var soundVol = 1.0
export(float) var musicVol = 1.0
export(bool) var finishedAnt = false
export(bool) var finishedBee = false
export(bool) var finishedBeetle = false
export(bool) var finishedSpider = false


func save():
	var save_dict = {
		"filename" : get_filename(),
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
