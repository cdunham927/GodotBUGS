extends Node2D

export var hitString = ""
export var atk = 10.0
export var stunAmt = 1.5

export(PackedScene) var bloodSpray

#export var spawnsObj =  false
#export(PackedScene) var objToSpawn

func _ready():
	#get_tree().current_scene.get_node("Camera2D").add_trauma(0.0375)
	$CPUParticles2D.restart()

func _on_Area2D_area_entered(area):
	if area.is_in_group(hitString):
		area.Damage(atk)
		area.Stun(stunAmt)


func _on_Timer_timeout():
	#if spawnsObj:
	#	SpawnObj()
	queue_free()

#func SpawnObj():
#	var o = objToSpawn.instance()
#	o.global_position = global_position
#	get_tree().current_scene.add_child(o)

func SpawnBlood():
	#print("Spawned by: " + self.name)
	#blood particles
	var blood_instance = bloodSpray.instance()
	blood_instance.emitting = true
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	#if (player != null):
	#	blood_instance.rotation = global_position.angle_to_point(player.global_position)
	#blood_instance.emitting = true
	#pass

func _on_Area2D_body_entered(body):
	if body.is_in_group(hitString):
		body.Damage(atk)
		if stunAmt > 0:
			body.Stun(stunAmt)
