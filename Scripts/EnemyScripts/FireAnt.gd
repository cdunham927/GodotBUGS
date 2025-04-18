extends "res://Scripts/EnemyScripts/Enemy.gd"

@export var fireBlob: PackedScene
@export var numShots: int = 3
var dir : int = 1
@export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true
	
func Chase(d):
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		if dir == -1:
			global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) + 179.5, lookAtSpd * d)
		else:
			global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) - 0.5, lookAtSpd * d)
			
		var dis = global_position.distance_to(player.global_position)
		if dis >= closestDistance:
			move_and_collide(-global_transform.y * spd * d)
		
		rotation_degrees += curTurn * d
		#move_and_collide(-global_transform.y * spd * d)
		
		if chaseCools <= 0:
			resetChaseCools = randf_range(chaseCooldownSmall, chaseCooldownBig)
			canShoot = true
			ChangeState(States.idle)
		
		if chaseCools > 0:
			chaseCools -= d

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

func Patrol(d):
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		#global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		if dir == -1:
			global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) + 179.5, lookAtSpd * d)
		else:
			global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) - 0.5, lookAtSpd * d)
			
		var dis = global_position.distance_to(player.global_position)
		if dis >= closestDistance:
			move_and_collide(-global_transform.y * spd * d)
		
		rotation_degrees += curTurn * d
		#move_and_collide(-global_transform.y * spd * d)
		
		if chaseCools <= 0:
			resetChaseCools = randf_range(chaseCooldownSmall, chaseCooldownBig)
			canShoot = true
			ChangeState(States.idle)
		
		if chaseCools > 0:
			chaseCools -= d

func Idle(d):
	if curStun <= 0:
		
		if canShoot and attackCools <= 0:
			canShoot = false
			Attack()
	
		if resetChaseCools > 0:
			resetChaseCools -= d
		
		if resetChaseCools <= 0:
			curTurn = randf_range(-turnSpd, turnSpd)
			chaseCools = randf_range(walkTimeSmall, walkTimeBig)
			ChangeState(States.patrol)

func Attack():
	Shoot()
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func Shoot():
	#Aim vaguely towards the player
	var vec_to_player = global_position - player.global_position
	vec_to_player = vec_to_player.normalized()
	var rot = atan2(vec_to_player.y, vec_to_player.x) + 89.5
	
	var b = fireBlob.instantiate()
	b.start(Callable(global_position, rot).bind(accuracy))
	b.atk = atk
	get_tree().current_scene.add_child(b)


func _on_Timer_timeout():
	dir *= -1
