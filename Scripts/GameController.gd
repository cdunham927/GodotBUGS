extends Node2D

var paused : bool = false
onready var pauseMenu = get_node("/root/World/PauseRoot")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Pause()
 
func Pause():
	#if paused:
	#	paused = false
	#	get_tree().paused = false
	#	pauseMenu.hide()
	#else:
	#	paused = true
	#	get_tree().paused = true
	#	pauseMenu.show()
	#paused = true
	get_tree().paused = true
	pauseMenu.show()
