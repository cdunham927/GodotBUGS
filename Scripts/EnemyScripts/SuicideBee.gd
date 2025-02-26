extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var explosion
export(PackedScene) var honeySplat
export(PackedScene) var smallerSplats
export(int) var extraSplats = 4
var extras

export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true

#Ranged attack stuff
export(PackedScene) var honeyBullet
export(int) var numShots = 3
export var farthestRangedDistance : float = 250
export var closestRangedDistance : float = 250
var curDistance : float = 0
var midpoint : float
export var rangedCoolsSmall : float = 1
export var rangedCoolsBig : float = 1

export(float) var sideSpeed = 1.0
export(float) var sideVariability = 1.0
var curSpd
export(float) var dashTime = 1.0
var actualDashTime : float = 0.0
export(float) var dashTimeVariability = 1.0
export(float) var waitTimeLow = 0.5
export(float) var waitTimeHigh = 1.0
var dir : float
var dir2 : float
var dashCools : float

func _ready():
	var dif = farthestRangedDistance - closestRangedDistance
	midpoint = closestRangedDistance + rand_range(0, dif)

func Animate():
	pass
	
func Attack():
	#Spawn honey
	var h = honeySplat.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func Idle(d):
	if canShoot:
		canShoot = false
		Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		curTurn = rand_range(-turnSpd, turnSpd)
		chaseCools = rand_range(walkTimeSmall, walkTimeBig)
		ChangeState(States.patrol)
	
		
var leftAngle
var rightAngle

func Chase(d):
	if curStun <= 0:
		if player != null:
			curDistance = global_position.distance_to(player.global_position)
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
		
		#leftAngle = vec_to_player + Vector2.RIGHT
		#leftAngle = (player.global_position - global_position)
		#rightAngle = vec_to_player - Vector2.RIGHT
		#rightAngle = player.global_position - global_position
	
		if curDistance > midpoint:
			move_and_collide(vec_to_player * spd * d)
		
	if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
		RangedAttack()
		
	if actualDashTime > 0:
		actualDashTime -= d
		
		if dir > 0.5:
			move_and_collide(transform.x * curSpd * d)
		else:
			move_and_collide(-transform.x * curSpd * d)

func RangedAttack():
	for i in range(numShots):
		Shoot()
	attackCools = rand_range(rangedCoolsSmall, rangedCoolsBig)
	
func Shoot():
	var b = honeyBullet.instance()
	b.start(global_position, global_rotation + PI, accuracy)
	b.atk = atk
	get_tree().current_scene.add_child(b)

func Patrol(d):
	rotation_degrees += curTurn * d
	move_and_collide(-global_transform.y * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
		canShoot = true
		ChangeState(States.idle)
		
	if chaseCools > 0:
		chaseCools -= d

func Explode():
	#Spawn explosion
	var e = explosion.instance()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	
	#Spawn honey
	var h = honeySplat.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	
	#Spawn extra honey
	extras = (randi() % extraSplats) + 1
	for i in extras:
		var ex = smallerSplats.instance()
		get_tree().current_scene.add_child(ex)
		ex.global_position = global_position
	
	Damage(999)

func _on_Timer_timeout():
	if curDistance > midpoint:
		dir2 = 1
	else:
		dir2 = -1
		
	var dif = farthestRangedDistance - closestRangedDistance
	midpoint = closestRangedDistance + rand_range(0, dif)
	
	if dir > 0.5:
		dir = -1
	else:
		dir = 1
		
	curSpd = sideSpeed + rand_range(0, sideVariability)
	actualDashTime = dashTime + rand_range(0, dashTimeVariability)
	
	$Timer.wait_time = rand_range(waitTimeLow, waitTimeHigh)


func _on_WalkTimer_timeout():
	play_random_sound(true, walkSrc)
