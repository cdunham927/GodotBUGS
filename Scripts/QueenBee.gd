extends "res://Scripts/EnemyScripts/Enemy.gd"

onready var bossUI = get_node("/root/World/BossUI")
onready var healthbar = get_node("/root/World/BossUI/BossHpBG")
onready var healthbarBG = get_node("/root/World/BossUI/BossHpBG/BossHpActual")
export var hpLerp : float = 2
export var hpBGLerp : float = 7

#export(PackedScene) var explosion
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
export(int) var minShots = 3
export(int) var maxShots = 3
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
var actualDashTime
export(float) var dashTimeVariability = 1.0
export(float) var waitTimeLow = 0.5
export(float) var waitTimeHigh = 1.0
var dir : float
var dir2 : float
var dashCools : float

var spinAttackCools : float = 0.0
export(float) var spinCooldown = 0.75
export(float) var spinSpd

export(float) var dmgToSpawnEnemy
export(PackedScene) var wave1
var waveSpawned1 : bool = false
export(float) var dmgToSpawnEnemy2
export(PackedScene) var wave2
var waveSpawned2 : bool = false
export(float) var dmgToSpawnEnemy3
export(PackedScene) var wave3
var waveSpawned3 : bool = false

#Attack variation
export var numRangedAttacksSmall : int = 2
export var numRangedAttacksBig : int = 4
export var curRangedAttacks : int = 2
var curRanged : int = 0

func _ready():
	if bossUI == null:
		bossUI = get_node("/root/World2/BossUI")
	bossUI.show()
		
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
	midpoint = closestRangedDistance + rand_range(0, dif)
	
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
			
		attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
		#ChangeState(States.attack)
		
	if spinAttackCools > 0 and curStun <= 0:
		spinAttackCools -= delta
		
	#if curState == States.attack and curStun <= 0:
	#	rotation_degrees += spinSpd * delta

func Attack():
	numShots = (randi() % (maxShots - minShots)) + minShots
	print("Shots: ", numShots)

	for i in range(numShots):
		Shoot()
	attackCools = rand_range(rangedCoolsSmall, rangedCoolsBig)
	pass
	
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
		attackCools = $Timer.wait_time + $LungeStart.wait_time + rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func HoneyAttack():
	#Spawn honey
	var h = honeySplat.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
func Idle(d):
	#if canShoot and attackCools <= 0:
	#	canShoot = false
	#	Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		curTurn = rand_range(-turnSpd, turnSpd)
		chaseCools = rand_range(walkTimeSmall, walkTimeBig)			
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
		RangedAttack()
		
	#if actualDashTime > 0:
	#	actualDashTime -= d
		
	#	if dir > 0.5:
	#		move_and_collide(transform.x * curSpd * d)
	#	else:
	#		move_and_collide(-transform.x * curSpd * d)

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
	if bossUI == null:
		bossUI = get_node("/root/World2/BossUI")
	bossUI.hide()
	
	queue_free()
	
func SpawnWave1():
	var h = wave1.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned1 = true
	
func SpawnWave2():
	#Spawn honey
	var h = wave2.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned2 = true
	
func SpawnWave3():
	#Spawn honey
	var h = wave3.instance()
	get_tree().current_scene.add_child(h)
	h.global_position = global_position
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	waveSpawned3 = true