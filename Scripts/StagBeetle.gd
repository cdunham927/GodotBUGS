extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var bullet
export(int) var numShots = 3
var dir : int = 1
export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true
	
func Chase(d):
	rotation_degrees += curTurn * d
	move_and_collide(-global_transform.y * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
		canShoot = true
		ChangeState(States.idle)
		
	if chaseCools > 0:
		chaseCools -= d

func Patrol(d):
	rotation_degrees += curTurn * d
	move_and_collide(-global_transform.y * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
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

func Attack():
	for i in range(numShots):
		Shoot()

func Shoot():
	var b = bullet.instance()
	b.start(global_position, global_rotation, accuracy)
	b.atk = atk
	get_tree().current_scene.add_child(b)
	
func _on_Area2D_body_entered(body):
	pass


func _on_Area2D_body_exited(body):
	pass
