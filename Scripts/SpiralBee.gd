extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var bullet
var dir : int = 1
export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true

var spinAttackCools : float = 0.0
export(float) var spinCooldown = 0.75
export(float) var spinSpd

func _ready():
	curState = States.chase
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func _process(delta):
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if attackCools <= 0:
		#if curState == States.chase:
		#	$Timer.start()
		$Timer.start()
			
		attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
		ChangeState(States.attack)
		
	if spinAttackCools > 0 and curStun <= 0:
		spinAttackCools -= delta
		
	if curState == States.attack and curStun <= 0:
		rotation_degrees += spinSpd * delta

func Idle(d):
	#if canShoot:
	#	canShoot = false
	#	Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		#curTurn = rand_range(-turnSpd, turnSpd)
		chaseCools = rand_range(walkTimeSmall, walkTimeBig)
		ChangeState(States.chase)

func Chase(d):
	if curStun <= 0:
		rotation_degrees += curTurn * d
		move_and_collide(-global_transform.y * spd * d)
		
		if chaseCools <= 0:
			resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
			ChangeState(States.idle)
		
		if chaseCools > 0:
			chaseCools -= d
		
func Attack():
	if spinAttackCools <= 0 and curStun <= 0:
		spinAttackCools = spinCooldown
		Shoot()
		
func Shoot(rot = 0):
	var b = bullet.instance()
	b.start(global_position, global_rotation + PI + rot, accuracy)
	b.atk = atk
	get_tree().current_scene.add_child(b)

func Animate():
	pass

func _on_Timer_timeout():
	#attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	#curTurn = rand_range(-turnSpd, turnSpd)
	#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	ChangeState(States.idle)