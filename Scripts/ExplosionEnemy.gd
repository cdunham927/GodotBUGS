extends Node2D

export var hitString = ""
export var atk = 10.0
export var stunAmt = 1.5

export(float) var colorLerp
export(Color) var endColor

#export var spawnsObj =  false
#export(PackedScene) var objToSpawn

func _ready():
	#get_tree().current_scene.get_node("Camera2D").add_trauma(0.0375)
	$CPUParticles2D.restart()

func _on_Area2D_area_entered(area):
	if area.is_in_group(hitString):
		area.Damage(atk)
		if area.has_method("Stun"):
			 area.Stun(stunAmt)

func _on_Timer_timeout():
	#emitting = false
	$Area2D/CollisionShape2D.disabled = true

func _process(delta):
	$CPUParticles2D.color = lerp($CPUParticles2D.color, endColor, colorLerp * delta)

func _on_Timer2_timeout():
	$CPUParticles2D.speed_scale = 0.0045

func _on_Area2D_body_entered(body):
	if body.is_in_group(hitString):
		body.Damage(atk)
		if stunAmt > 0:
			body.Stun(stunAmt)


func _on_Timer3_timeout():
	queue_free()
