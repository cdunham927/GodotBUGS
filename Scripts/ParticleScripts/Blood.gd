extends CPUParticles2D

export(float) var colorLerp
export(Color) var endColor

func _process(delta):
	color = lerp(color, endColor, colorLerp * delta)

func _on_Timer_timeout():
	#get_tree().paused = true
	#get_tree()
	speed_scale = 0.0045
	
	#print("Turn off particles")
	#set_process(false)
	#set_physics_process(false)
	#set_process_input(false)
	#set_physics_process_internal(false)
	#set_process_unhandled_input(false)
	#set_process_unhandled_key_input(false)


func _on_Timer2_timeout():
	queue_free()
