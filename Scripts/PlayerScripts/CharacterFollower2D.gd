extends PathFollow2D

export var runSpd = 20
var player
var active : bool = false
var parentWaypoint

func _ready():
	parentWaypoint = get_parent().get_parent()
	player = get_node("/root/World/OverworldPlayer")

func _process(delta):
	if player == null:
		player = get_node("/root/World/OverworldPlayer")
	
	if player != null and active:
		set_offset(get_offset() + runSpd * delta)
		
		if unit_offset == 1:
			parentWaypoint.moving = false
			#parentWaypoint.currentWaypoint = null
			active = false
			pass
	#progress += runSpd * delta
	
