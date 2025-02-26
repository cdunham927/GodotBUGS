extends Node

export(float) var masterVol
export(float) var soundVol
export(float) var musicVol


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"masterVol" : masterVol,
		"musicVol" : musicVol,
		"soundVol" : soundVol,
	}
	return save_dict
