extends "res://Scripts/EnemyScripts/Enemy.gd"

export(int) var numShots = 3

func _ready():
	add_to_group("enemies")
	#params: name, blend, play speed
	#anim.play("move", 1, 2)
	
	curAimOffsetTimer = aimOffsetTimer
	curAimOffset = rand_range(-aimOffset, aimOffset)
	
	rotation_degrees = rand_range(0, 360)
	
	chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func Chase(d):
	if chaseCools > 0:
		var vec_to_player = global_position - player.global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
		move_and_collide(vec_to_player * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
		ChangeState(States.idle)
		#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
		
	if chaseCools > 0:
		chaseCools -= d
		
	if attackCools <= 0:
		Attack()
		
func Idle(d):
	if resetChaseCools <= 0:
		#print("Resetting chase timer")
		chaseCools = rand_range(walkTimeSmall, walkTimeBig)
		ChangeState(States.chase)
		
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if attackCools <= 0:
		Attack()

func Attack():
	for i in range(numShots):
		Shoot()
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func Shoot():
	var b = bulletPool.GetPoolObject()
	b.atk = atk
	b.start(global_position, global_rotation, accuracy)
	world.add_child(b)
	b.show()
	
