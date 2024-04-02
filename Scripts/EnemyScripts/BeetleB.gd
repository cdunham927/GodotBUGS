extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var bullet
export(int) var numShots = 3
var dir : int = 1
export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true
	
func Chase(d):
	pass

func Patrol(d):	
	rotation_degrees += curTurn * d
	move_and_collide(-global_transform.y * spd * d)
		
	if chaseCools <= 0:
		resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
		canShoot = true
		ChangeState(States.idle)
		
	if chaseCools > 0:
		chaseCools -= d

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
