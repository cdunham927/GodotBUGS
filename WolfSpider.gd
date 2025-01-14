extends "res://Scripts/EnemyScripts/Enemy.gd"

export(float) var sideSpeed = 1.0
export(float) var sideVariability = 1.0
var curSpd
export(float) var dashTime = 1.0
var actualDashTime
export(float) var dashTimeVariability = 1.0
export(float) var waitTimeLow = 0.5
export(float) var waitTimeHigh = 1.0
var dir : float
var dashCools : float

func _ready():
	Setup()
	actualDashTime = dashTime + rand_range(0, dashTimeVariability)
	curSpd = sideSpeed + rand_range(0, sideVariability)
	randomize()
	
	var x = rand_range(0, 1)
	if x > 0.5:
		dir = 1
	else:
		dir = -1

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
			upd5 = legUpd5.global_position
	if leg6 != null and legUpd6 != null:
		leg6.step(upd6)
		if leg6.global_position.distance_to(upd6) > maxLegDist:
			upd6 = legUpd6.global_position
	if leg7 != null and legUpd7 != null:
		leg7.step(upd5)
		if leg7.global_position.distance_to(upd7) > maxLegDist:
			upd7 = legUpd7.global_position
	if leg8 != null and legUpd8 != null:
		leg8.step(upd8)
		if leg8.global_position.distance_to(upd8) > maxLegDist:
			upd8 = legUpd8.global_position

func Chase(d):
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		#global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) + 89.5, lookAtSpd * d)
		
		var leftAngle = vec_to_player + Vector2.RIGHT
		var rightAngle = vec_to_player - Vector2.RIGHT
		
		var dis = global_position.distance_to(player.global_position)
		#if dis >= closestDistance:
		#	move_and_collide(vec_to_player * spd * d)
		
		if actualDashTime > 0:
			actualDashTime -= d
	
			if dir > 0.5:
				move_and_collide(leftAngle * curSpd * d)
				#move_and_collide(Vector2(-position.x * sideSpeed * d, -position.y * sideSpeed * d))
				#move_and_collide((vec_to_player * sideSpeed * d) + Vector2(-position.x * sideSpeed * d, 0))
				pass
			else:
				move_and_collide(rightAngle * curSpd * d)
				#move_and_collide(Vector2(position.x * sideSpeed * d, -position.y * sideSpeed * d))
				#move_and_collide((vec_to_player * sideSpeed * d) + Vector2(position.x * sideSpeed * d, 0))
				pass


func _on_Timer_timeout():
	if dir > 0.5:
		dir = -1
	else:
		dir = 1
		
	curSpd = sideSpeed + rand_range(0, sideVariability)
	actualDashTime = dashTime + rand_range(0, dashTimeVariability)
	
	$Timer.wait_time = rand_range(waitTimeLow, waitTimeHigh)
