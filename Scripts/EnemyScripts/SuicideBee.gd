extends "res://Scripts/EnemyScripts/Enemy.gd"

@export var explosion: PackedScene
@export var honeySplat: PackedScene
@export var smallerSplats: PackedScene
@export var extraSplats: int = 4
var extras

@export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true

#Ranged attack stuff
@export var honeyBullet: PackedScene
@export var numShots: int = 3
@export var farthestRangedDistance : float = 250
@export var closestRangedDistance : float = 250
var curDistance : float = 0
var midpoint : float
@export var rangedCoolsSmall : float = 1
@export var rangedCoolsBig : float = 1

@export var sideSpeed: float = 1.0
@export var sideVariability: float = 1.0
var curSpd
@export var dashTime: float = 1.0
var actualDashTime : float = 0.0
@export var dashTimeVariability: float = 1.0
@export var waitTimeLow: float = 0.5
@export var waitTimeHigh: float = 1.0
var dir : float
var dir2 : float
var dashCools : float

func _ready():
	var dif = farthestRangedDistance - closestRangedDistance
	midpoint = closestRangedDistance + randf_range(0, dif)

func Animate():
	pass
	
func Attack():
	#Spawn honey
	var h = honeySplat.instantiate()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func Idle(d):
	if canShoot:
		canShoot = false
		Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		curTurn = randf_range(-turnSpd, turnSpd)
		chaseCools = randf_range(walkTimeSmall, walkTimeBig)
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
	attackCools = randf_range(rangedCoolsSmall, rangedCoolsBig)
	
func Shoot():
	var b = honeyBullet.instantiate()
	b.start(Callable(global_position, global_rotation + PI).bind(accuracy))
	b.atk = atk
	get_tree().current_scene.add_child(b)

func Patrol(d):
	rotation_degrees += curTurn * d
	move_and_collide(-global_transform.y * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = randf_range(chaseCooldownSmall, chaseCooldownBig)
		canShoot = true
		ChangeState(States.idle)
		
	if chaseCools > 0:
		chaseCools -= d

func Explode():
	#Spawn explosion
	var e = explosion.instantiate()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	
	#Spawn honey
	var h = honeySplat.instantiate()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	
	#Spawn extra honey
	extras = (randi() % extraSplats) + 1
	for i in extras:
		var ex = smallerSplats.instantiate()
		get_tree().current_scene.add_child(ex)
		ex.global_position = global_position
	
	Damage(999)

func _on_Timer_timeout():
	if curDistance > midpoint:
		dir2 = 1
	else:
		dir2 = -1
		
	var dif = farthestRangedDistance - closestRangedDistance
	midpoint = closestRangedDistance + randf_range(0, dif)
	
	if dir > 0.5:
		dir = -1
	else:
		dir = 1
		
	curSpd = sideSpeed + randf_range(0, sideVariability)
	actualDashTime = dashTime + randf_range(0, dashTimeVariability)
	
	$Timer.wait_time = randf_range(waitTimeLow, waitTimeHigh)


func _on_WalkTimer_timeout():
	play_random_sound(true, walkSrc)
