extends "res://Scripts/EnemyScripts/Enemy.gd"

@onready var bossUI = get_node("/root/World/BossUI")
@onready var healthbar = get_node("/root/World/MapPart11/BossUI/BossHpBG")
@onready var healthbarBG = get_node("/root/World/MapPart11/BossUI/BossHpBG/BossHpActual")
@export var hpLerp : float = 2
@export var hpBGLerp : float = 7

#export(PackedScene) var explosion
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
@export var minShots: int = 3
@export var maxShots: int = 3
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
var actualDashTime
@export var dashTimeVariability: float = 1.0
@export var waitTimeLow: float = 0.5
@export var waitTimeHigh: float = 1.0
var dir : float
var dir2 : float
var dashCools : float

var spinAttackCools : float = 0.0
@export var spinCooldown: float = 0.75
@export var spinSpd: float

@export var dmgToSpawnEnemy: float
@export var wave1: PackedScene
var waveSpawned1 : bool = false
@export var dmgToSpawnEnemy2: float
@export var wave2: PackedScene
var waveSpawned2 : bool = false
@export var dmgToSpawnEnemy3: float
@export var wave3: PackedScene
var waveSpawned3 : bool = false

#Attack variation
@export var numRangedAttacksSmall : int = 2
@export var numRangedAttacksBig : int = 4
@export var curRangedAttacks : int = 2
var curRanged : int = 0

var gc

func _ready():
	gc = get_parent()
	
	#if bossUI == null:
	#	bossUI = get_node("/root/World/BossUI")
	#	bossUI.show()
		
	if healthbar == null:
		healthbar = get_node("/root/World2/BossUI/BossHpBG/BossHpActual")
	if healthbarBG == null:
		healthbarBG = get_node("/root/World2/BossUI/BossHpBG")
		
	if healthbar != null:
		healthbar.value = maxHp
		healthbar.max_value = maxHp
	if healthbarBG != null:
		healthbarBG.value = maxHp
		healthbarBG.max_value = maxHp
		
	var dif = farthestRangedDistance - closestRangedDistance
	midpoint = closestRangedDistance + randf_range(0, dif)
	
	curRangedAttacks = (randi() % (numRangedAttacksBig - numRangedAttacksSmall)) + numRangedAttacksSmall
	numShots = (randi() % (maxShots - minShots)) + minShots
	
	print("Ranged attacks: ", curRangedAttacks)

func _process(delta):
	if healthbar != null:
		healthbar.value = lerp(healthbar.value, hp, hpLerp * delta)
	if healthbarBG != null:
		healthbarBG.value = lerp(healthbarBG.value, hp, hpBGLerp * delta)
	
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if attackCools <= 0:
		#if curState == States.chase:
		#	$Timer.start()
		$Timer.start()
			
		attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
		#ChangeState(States.attack)
		
	if spinAttackCools > 0 and curStun <= 0:
		spinAttackCools -= delta
		
	#if curState == States.attack and curStun <= 0:
	#	rotation_degrees += spinSpd * delta

func Attack():
	numShots = (randi() % (maxShots - minShots)) + minShots
	#print("Shots: ", numShots)

	for i in range(numShots):
		Shoot()
	attackCools = randf_range(rangedCoolsSmall, rangedCoolsBig)
	
func DoubleAttack():
	if curRanged < curRangedAttacks:
		#print("ranged attack")
		Attack()
		curRanged += 1
	else:
		#Honey spawns
		HoneyAttack()
		curRangedAttacks = (randi() % (numRangedAttacksBig - numRangedAttacksSmall)) + numRangedAttacksSmall
		curRanged = 0
	
func HoneyAttack():
	#Spawn honey
	for x in $HoneyPositions.get_children():
		var h = honeySplat.instantiate()
		get_tree().current_scene.add_child(h)
		h.global_position = x.global_position
		var sh = smallerSplats.instantiate()
		get_tree().current_scene.add_child(sh)
		sh.global_position = x.global_position
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func Idle(d):
	#if canShoot and attackCools <= 0:
	#	canShoot = false
	#	Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		curTurn = randf_range(-turnSpd, turnSpd)
		chaseCools = randf_range(walkTimeSmall, walkTimeBig)			
		ChangeState(States.patrol)
		
		
	if player != null:
		curDistance = global_position.distance_to(player.global_position)
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
	
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
		
	#if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
	if attackCools <= 0 and curStun <= 0:
		DoubleAttack()
		
	#if actualDashTime > 0:
	#	actualDashTime -= d
		
	#	if dir > 0.5:
	#		move_and_collide(transform.x * curSpd * d)
	#	else:
	#		move_and_collide(-transform.x * curSpd * d)

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
		
	#if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
	if attackCools <= 0 and curStun <= 0:
		RangedAttack()

#func Explode():
	#Spawn explosion
#	var e = explosion.instance()
#	get_tree().current_scene.add_child(e)
#	e.global_position = global_position
	
	#Spawn honey
#	var h = honeySplat.instance()
#	get_tree().current_scene.add_child(h)
#	h.global_position = global_position
	
	#Spawn extra honey
#	extras = (randi() % extraSplats) + 1
#	for i in extras:
#		var ex = smallerSplats.instance()
#		get_tree().current_scene.add_child(ex)
#		ex.global_position = global_position
	
#	Damage(999)

#func _on_Timer_timeout():
#	if curDistance > midpoint:
#		dir2 = 1
#	else:
#		dir2 = -1
#		
#	var dif = farthestRangedDistance - closestRangedDistance
#	midpoint = closestRangedDistance + rand_range(0, dif)
#	
#	if dir > 0.5:
#		dir = -1
#	else:
#		dir = 1
#		
#	curSpd = sideSpeed + rand_range(0, sideVariability)
#	actualDashTime = dashTime + rand_range(0, dashTimeVariability)
#	
#	$Timer.wait_time = rand_range(waitTimeLow, waitTimeHigh)
	
	pass

func Damage(amt):
	if paused:
		return
		
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator" and amt >= flashMinDmg:
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
	hp -= amt
	
	if hp < dmgToSpawnEnemy and !waveSpawned1:
		SpawnWave1()
	if hp < dmgToSpawnEnemy2 and !waveSpawned2:
		SpawnWave2()
	if hp < dmgToSpawnEnemy3 and !waveSpawned3:
		SpawnWave3()
	
	if hp <= 0:
		kill()

func kill():
	play_sound(snd, true)
	SpawnBlood()
	#if bossUI == null:
	#	bossUI = get_node("/root/World2/BossUI")
	bossUI.hide()
	
	gc.Victory()
	
	queue_free()
	
func SpawnWave1():
	var h = wave1.instantiate()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned1 = true
	
func SpawnWave2():
	#Spawn honey
	var h = wave2.instantiate()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned2 = true
	
func SpawnWave3():
	#Spawn honey
	var h = wave3.instantiate()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned3 = true


func _on_WalkTimer_timeout():
	play_random_sound(true, walkSrc)

