extends "res://Scripts/EnemyScripts/Enemy.gd"

@export var sideSpeed: float = 1.0
@export var sideVariability: float = 1.0
var curSpd
@export var dashTime: float = 1.0
var actualDashTime
@export var dashTimeVariability: float = 1.0
@export var waitTimeLow: float = 0.5
@export var waitTimeHigh: float = 1.0
var dir : float
@export var farthestRangedDistance : float = 250
@export var closestRangedDistance : float = 250
var midpoint : float
var curDistance : float = 0
var dashCools : float

var hasAdded = false

@export var pushSpd: float = 10.0

func _ready():
	if get_parent().get_parent() != null:
		get_parent().get_parent().numSpiders += 1
	else:
		get_parent().get_parent().get_parent().numSpiders += 1
	Setup()
	actualDashTime = dashTime + randf_range(0, dashTimeVariability)
	curSpd = sideSpeed + randf_range(0, sideVariability)
	randomize()
	midpoint = (closestRangedDistance + farthestRangedDistance) / 2
	
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
	
	var x = randf_range(0, 1)
	if x > 0.5:
		dir = 1
	else:
		dir = -1

func Animate():
	if leg != null and legUpd != null:
		leg.step(upd1)
		if leg.global_position.distance_to(upd1) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			#print(leg.global_position.distance_to(upd1))
			upd1 = legUpd.global_position
	if leg2 != null and legUpd2 != null:
		leg2.step(upd2)
		if leg2.global_position.distance_to(upd2) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd2 = legUpd2.global_position
	if leg3 != null and legUpd3 != null:
		leg3.step(upd3)
		if leg3.global_position.distance_to(upd3) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd3 = legUpd3.global_position
	if leg4 != null and legUpd4 != null:
		leg4.step(upd4)
		if leg4.global_position.distance_to(upd4) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd4 = legUpd4.global_position
	if leg5 != null and legUpd5 != null:
		leg5.step(upd5)
		if leg5.global_position.distance_to(upd5) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd5 = legUpd5.global_position
	if leg6 != null and legUpd6 != null:
		leg6.step(upd6)
		if leg6.global_position.distance_to(upd6) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd6 = legUpd6.global_position
	if leg7 != null and legUpd7 != null:
		leg7.step(upd5)
		if leg7.global_position.distance_to(upd7) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd7 = legUpd7.global_position
	if leg8 != null and legUpd8 != null:
		leg8.step(upd8)
		if leg8.global_position.distance_to(upd8) > maxLegDist:
			if !playingWalk:
				playingWalk = true
				play_sound(walkSnd, true, walkSrc)
				$WalkTimer.start()
			upd8 = legUpd8.global_position

func Chase(d):
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		#global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) + 89.5, lookAtSpd * d)
		
		var dis = global_position.distance_to(player.global_position)
	
		if dis > midpoint:
			move_and_collide(vec_to_player * spd * d)
		
		if actualDashTime > 0:
			actualDashTime -= d
		
	if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
		ChangeState(States.attack)

func Attack():
	if attackCools <= 0:
		#$ExitJumpTimer.start()
		$TeleportTimer.start()
		JumpAttack()
		#ChangeState(States.chase)

func JumpAttack():
	if anim != null:
		anim.play("Jump", 1, 1)
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func _on_Timer_timeout():
	if dir > 0.5:
		dir = -1
	else:
		dir = 1
		
	curSpd = sideSpeed + randf_range(0, sideVariability)
	actualDashTime = dashTime + randf_range(0, dashTimeVariability)
	
	$Timer.wait_time = randf_range(waitTimeLow, waitTimeHigh)

func kill():
	play_sound(snd, true)
	if !hasAdded:
		if get_parent().get_parent() != null:
			get_parent().get_parent().numSpiders += 1
		else:
			get_parent().get_parent().get_parent().numSpiders += 1
		hasAdded = true
	SpawnBlood()
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Area2D.monitoring = false
		inSight = true
		ChangeState(States.chase)

func _on_ExitJumpTimer_timeout():
	#anim.play("idle")
	ChangeState(States.chase)

func _on_AOEArea_area_entered(area):
	#print(body.name)
	if area.name == "Player":
		print("Hit player area")
		area.AOEDamage(atk, global_position, pushSpd)
		$AOEArea.monitoring = false

func _on_AOEArea_body_entered(body):
	#print(body.name)
	if body.name == "Player":
		#print("Hit player body")
		body.AOEDamage(atk, global_position, pushSpd)
		$AOEArea.monitoring = false

func _on_TeleportTimer_timeout():
	global_position = player.global_position
	#$AOEArea.monitoring = false
