extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var coccoon
export(PackedScene) var aoeBullet
export(int) var numShots = 3
export(int) var AOEShots = 3
var dir : int = 1
#export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true

export var tillWebAOE : int = 2
var curAttacks : int = 0
export var farthestRangedDistance : float = 250
export var closestRangedDistance : float = 250
var curDistance : float = 0
var midpoint : float
export var rangedCoolsSmall : float = 1
export var rangedCoolsBig : float = 1

func _ready():
	curAttacks = 0
	midpoint = (closestRangedDistance + farthestRangedDistance) / 2

func _process(delta):
	if player != null:
		curDistance = global_position.distance_to(player.global_position)
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
	
func Idle(d):
	#if canShoot:
	#	canShoot = false
	#	Attack()
	
	if resetChaseCools > 0:
		resetChaseCools -= d
		
	if resetChaseCools <= 0:
		#curTurn = rand_range(-turnSpd, turnSpd)
		chaseCools = rand_range(walkTimeSmall, walkTimeBig)
		ChangeState(States.idle)
		
func Retreat(d):
	if curStun <= 0:
		var vec_to_player = global_position - player.global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		
		if attackCools <= 0:
			Attack()

func Chase(d):
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
	
		if curDistance > midpoint:
			move_and_collide(vec_to_player * spd * d)
		
	if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
		ChangeState(States.attack)

func RangedAttack():
	var a = coccoon.instance()
	a.global_position = global_position
	get_tree().current_scene.add_child(a)
	attackCools = rand_range(rangedCoolsSmall, rangedCoolsBig)
	ChangeState(States.retreat)
	
func AOEAttack():
	var ind = accuracy / AOEShots
	for i in range(AOEShots):
		var b = aoeBullet.instance()
		b.start(global_position, global_rotation + PI, (global_rotation + PI) - accuracy + (i * ind))
		b.atk = atk
		get_tree().current_scene.add_child(b)
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func Attack():
	if attackCools <= 0:
		if curAttacks < tillWebAOE:
			#print("ranged attack")
			RangedAttack()
			curAttacks += 1
			if anim != null:
				anim.play("Idle", 1, 1)
			ChangeState(States.chase)
		else:
			if anim != null:
				anim.play("AttackIndicator", 1, 1)
			#print("lunge attack")
			AOEAttack()
			curAttacks = 0

func Animate():
	if leg != null and legUpd != null:
		leg.step(upd1)
		if leg.global_position.distance_to(upd1) > maxLegDist:
			#print(leg.global_position.distance_to(upd1))
			upd1 = legUpd.global_position
	if leg2 != null and legUpd2 != null:
		leg2.step(upd2)
		if leg2.global_position.distance_to(upd2) > maxLegDist:
			upd2 = legUpd2.global_position
	if leg3 != null and legUpd3 != null:
		leg3.step(upd3)
		if leg3.global_position.distance_to(upd3) > maxLegDist:
			upd3 = legUpd3.global_position
	if leg4 != null and legUpd4 != null:
		leg4.step(upd4)
		if leg4.global_position.distance_to(upd4) > maxLegDist:
			upd4 = legUpd4.global_position
	if leg5 != null and legUpd5 != null:
		leg5.step(upd5)
		if leg5.global_position.distance_to(upd5) > maxLegDist:
			#print(leg.global_position.distance_to(upd1))
			upd5 = legUpd5.global_position
	if leg6 != null and legUpd6 != null:
		leg6.step(upd6)
		if leg6.global_position.distance_to(upd6) > maxLegDist:
			upd6 = legUpd6.global_position
	if leg7 != null and legUpd7 != null:
		leg7.step(upd7)
		if leg7.global_position.distance_to(upd7) > maxLegDist:
			upd7 = legUpd7.global_position
	if leg8 != null and legUpd8 != null:
		leg8.step(upd8)
		if leg8.global_position.distance_to(upd8) > maxLegDist:
			upd8 = legUpd8.global_position

