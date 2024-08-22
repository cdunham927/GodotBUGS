extends Area2D

func _on_EnemyFireArea_body_entered(body):
	if body.name == "Player":
		body.inFire = true
		#print("Player on fire")

func _on_EnemyFireArea_body_exited(body):
	if body.name == "Player":
		body.inFire = false
		#print("Player exiting fire")


func _on_DisableTimer_timeout():
	queue_free()
