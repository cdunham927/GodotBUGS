extends Node2D

@export var maxDeg: float
@export var rotSpd: float
var left : bool = false

#Rotate
func _physics_process(delta):
	
	var deg = sin(delta * rotSpd)
	
	if rotation_degrees < -maxDeg and left:
		left = false
	
	if rotation_degrees > maxDeg and !left:
		left = true
		
	
	if left:
		rotation_degrees -= deg
	else:
		rotation_degrees += deg
