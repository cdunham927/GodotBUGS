extends CPUParticles2D

func _on_Timer_timeout():
	#get_tree().paused = true
	
	#print("Turn off particles")
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	#set_process(ProcessMode) = PROCESS_MODE_DISABLED
	set_physics_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
