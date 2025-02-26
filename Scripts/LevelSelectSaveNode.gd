extends Node

export(bool) var finishedAnt
export(bool) var finishedBee
export(bool) var finishedBeetle
export(bool) var finishedSpider


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"finishedAnt" : finishedAnt,
		"finishedBee" : finishedBee,
		"finishedBeetle" : finishedBeetle,
		"finishedSpider" : finishedSpider,
	}
	return save_dict
