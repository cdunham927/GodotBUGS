extends Node2D

export var yspd = 10
var curYSpd
var curXSpd
export var lerpSpd = 3
export var rotLerpSpd = 3
var curRot = 3
export var xspd = 5
export var rotSpd = 15

export var lPel = false

func _ready():
	curXSpd = xspd
	curYSpd = yspd
	curRot = rotSpd

func _process(delta):
	curYSpd = lerp(curYSpd, 0, lerpSpd * delta)
	curXSpd = lerp(curXSpd, 0, lerpSpd * delta)
	curRot = lerp(curRot, 0, rotLerpSpd * delta)
	
	if lPel:
		global_position.x -= curXSpd * delta
		rotation_degrees -= curRot * delta
	else:
		global_position.x += curXSpd * delta
		rotation_degrees += curRot * delta
	global_position.y += curYSpd * delta

func _on_Timer_timeout():
	queue_free()
	#pass # Replace with function body.
