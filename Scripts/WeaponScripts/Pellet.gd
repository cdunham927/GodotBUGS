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

export var spawnsObj =  false
export(PackedScene) var objToSpawn

export var hitString = ""

func _ready():
	curXSpd = xspd
	curYSpd = yspd
	curRot = rotSpd

func _process(delta):
	curYSpd = lerp(curYSpd, 0, lerpSpd * delta)
	curXSpd = lerp(curXSpd, 0, lerpSpd * delta)
	curRot = lerp(curRot, 0, rotLerpSpd * delta)
	
	var xDir
	
	if lPel:
		#position.x -= curXSpd * delta
		xDir = -1
		rotation_degrees -= curRot * delta
	else:
		xDir = 1
		#position.x += curXSpd * delta
		rotation_degrees += curRot * delta
	position -= transform.y * curYSpd * delta
	position -= transform.x * curXSpd * delta * xDir
	#position -= moveDir * delta
	
	if curYSpd <= 0 and spawnsObj:
		SpawnObj()
		queue_free()

func _on_Timer_timeout():
	SpawnObj()
	queue_free()
	#pass # Replace with function body.

func _on_Area2D_area_entered(area):
	if area.is_in_group(hitString) and spawnsObj:
		SpawnObj()
		queue_free()

func SpawnObj():
	var o = objToSpawn.instance()
	o.hitString = hitString
	o.global_position = global_position
	get_tree().current_scene.add_child(o)
