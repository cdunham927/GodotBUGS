extends "res://Scripts/EnemyScripts/Enemy.gd"

export(PackedScene) var bullet
export(int) var numShots = 3
var dir : int = 1
#export var turnSpd : float = 5
var curTurn : float
var canShoot : bool = true

export var farthestRangedDistance : float = 250
export var closestRangedDistance : float = 250
var curDistance : float = 0
var midpoint : float

#Lunging stats
export var lunging : bool = false
export var aiming : bool = false
export var lungeSpd : float
export var lungeAtk = 5

func _ready():
	midpoint = (closestRangedDistance + farthestRangedDistance) / 2

func _process(delta):
	if player != null:
		curDistance = global_position.distance_to(player.global_position)
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if lunging:
		$LungeArea/CollisionShape2D.disabled = false
		$CollisionShape2D.disabled = true
		move_and_collide(-transform.y * lungeSpd * delta)
	else:
		$LungeArea/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = false
		#move_and_slide(-transform.y * lungeSpd)
		
	if aiming and curStun <= 0:
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

func Chase(d):
	if !lunging and curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5 
	
		if curDistance > midpoint:
			move_and_collide(vec_to_player * spd * d)
		
	if curDistance < farthestRangedDistance and attackCools <= 0 and curStun <= 0:
		ChangeState(States.attack)

func LungeStart():
	aiming = false
	lunging = true
	$Timer.start()
	
func ResetLunging():
	ChangeState(States.chase)
	lunging = false

func Attack():
	if attackCools <= 0 and !lunging:
		if anim != null:
			anim.play("AttackIndicator", 1, 1)
		#print("lunge attack")
		$LungeStart.start()
		aiming = true
		attackCools = $Timer.wait_time + $LungeStart.wait_time + rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)

func Shoot():
	if bullet != null:
		var b = bullet.instance()
		b.start(global_position, global_rotation + PI, accuracy)
		b.atk = atk
		get_tree().current_scene.add_child(b)

func Animate():
	pass

func _on_Timer_timeout():
	ResetLunging()
	
func _on_LungeStart_timeout():
	LungeStart()

func _on_LungeArea_body_entered(body):
	if body.name == "Player":
		body.Damage(lungeAtk)
		#curAtk -= 1
		#hp -= 1
		#if hp <= 0:
		#	Disable()