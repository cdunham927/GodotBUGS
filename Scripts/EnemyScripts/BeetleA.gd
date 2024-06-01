extends "res://Scripts/EnemyScripts/Enemy.gd"

export(int) var numShots = 3

export var turnSpd : float = 5
var curTurn : float
export(PackedScene) var bullet

func Chase(d):
	rotation_degrees += curTurn * d
	
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
		curTurn = rand_range(-turnSpd, turnSpd)
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
	var b = bullet.instance()
	b.start(global_position, global_rotation, accuracy)
	b.atk = atk
	get_tree().current_scene.add_child(b)
	b.show()
	
