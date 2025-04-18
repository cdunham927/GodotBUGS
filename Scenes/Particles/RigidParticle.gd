extends RigidBody2D

@export var curAtk : float = 1.0

func _on_RigidParticle_body_entered(body):
	#print(body.name)
	if body.is_in_group("Wall"):
		#SpawnPart(global_position)
		Disable()
	if body.is_in_group("enemies"):
		#print("Damaged by: ", curAtk)
		#if body.has_method("Knockback"):
		#	body.Knockback(knockback, -transform.y)
		if body.has_method("Damage"):
			body.Damage(curAtk)

func Disable():
	queue_free()
