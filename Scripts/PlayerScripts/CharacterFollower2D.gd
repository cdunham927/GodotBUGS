extends PathFollow2D

export var runSpd = 20

func _process(delta):
	set_offset(get_offset() + runSpd * delta)
	
