extends Node2D

var paused : bool = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Pause()	
 
func Pause():
	if paused:
		paused = false
		get_tree().paused = false
	else:
		paused = true
		get_tree().paused = true
