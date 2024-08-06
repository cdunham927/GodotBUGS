extends CPUParticles2D

export(float) var colorLerp
export(Color) var endColor

func _on_Timer_timeout():
	#emitting = false
	speed_scale = 0.0045

func _process(delta):
	color = lerp(color, endColor, colorLerp * delta)

func _on_Timer2_timeout():
	queue_free()
