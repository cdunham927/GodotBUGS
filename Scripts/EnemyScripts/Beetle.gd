extends "res://Scripts/EnemyScripts/Enemy.gd"

func Chase(d):
		var vec_to_player = global_position - player.global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		move_and_collide(vec_to_player * spd * d)
		
		if attackCools <= 0:
			Attack()

func Attack():
	Shoot()
	Shoot()
	Shoot()
	attackCools = timeBetweenAttacks

func Shoot():
	var b = bulletPool.GetPoolObject()
	b.start(global_position, global_rotation, accuracy)
	world.add_child(b)
	b.show()
	
