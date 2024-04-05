extends Node2D

export var hitString = ""
export var atk = 10.0

func _ready():
	get_tree().current_scene.get_node("Camera2D").add_trauma(0.0375)
	$CPUParticles2D.restart()

func _on_Area2D_area_entered(area):
	if area.is_in_group(hitString):
		area.Damage(atk)


func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group(hitString):
		body.Damage(atk)
