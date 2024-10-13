extends Node2D

export var yspd = 10
var curYSpd
var curXSpd
export var lerpSpd = 3
export var rotLerpSpd = 3
var curRot = 3
export var xspd = 5
export var rotSpd = 15
export var randRot = false
var randDir = 1

export var lPel = false

export var spawnsObj =  false
export(PackedScene) var objToSpawn

export var hitString = ""

func _ready():
	curXSpd = xspd
	curYSpd = yspd
	curRot = rotSpd
	
	if randf() > 0.5:
		randDir = 1
	else:
		randDir = -1

func _process(delta):
	curYSpd = lerp(curYSpd, 0, lerpSpd * delta)
	curXSpd = lerp(curXSpd, 0, lerpSpd * delta)
	curRot = lerp(curRot, 0, rotLerpSpd * delta)
	
	var xDir
	
	if lPel:
		#position.x -= curXSpd * delta
		xDir = -1
		#$Sprite.rotation_degrees -= curRot * delta
	else:
		xDir = 1
		#position.x += curXSpd * delta
		#$Sprite.rotation_degrees += curRot * delta
	if randRot:
		$Sprite.rotation_degrees += curRot * delta * randDir
	else:
		$Sprite.rotation_degrees += curRot * delta
	position -= transform.y * curYSpd * delta
	position -= transform.x * curXSpd * delta * xDir
	#position -= moveDir * delta
	
	#if curYSpd <= 0:
	#	if spawnsObj:
	#		SpawnObj()
		#queue_free()

func _on_Timer_timeout():
	if spawnsObj:
		SpawnObj()
	queue_free()
	#pass # Replace with function body.

func _on_Area2D_area_entered(area):
	if area.is_in_group("Wall"):
		if spawnsObj:
			SpawnObj()
		queue_free()
	if area.is_in_group(hitString) and spawnsObj:
		SpawnObj()
		queue_free()

func SpawnObj():
	var o = objToSpawn.instance()
	o.hitString = hitString
	o.global_position = global_position
	get_tree().current_scene.add_child(o)


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("Wall"):
		if spawnsObj:
			SpawnObj()
		queue_free()
	if body.is_in_group(hitString) and spawnsObj:
		SpawnObj()
		queue_free()
