extends Node2D

export var hitString = ""
export var atk = 10.0

func _on_Area2D_area_entered(area):
	if area.is_in_group(hitString):
		area.Damage(atk)
	queue_free()
