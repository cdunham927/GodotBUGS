extends KinematicBody2D

export(float) var hp = 4
export var spd = 200
export var atk = 5
 
onready var raycast = $RayCast2D
onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

enum States { idle, patrol, chase, attack, retreat, death }
var curState : int = States.idle

export(float) var timeBetweenAttacksSmall
export(float) var timeBetweenAttacksBig
var attackCools : float
 
#Stuff for projectile enemies
export var poolName = ""
onready var bulletPool = get_node("/root/World/" + poolName)
onready var world = get_node("/root/World")
export(float) var accuracy

export(float) var chaseCooldownSmall
export(float) var chaseCooldownBig
export(float) var walkTimeSmall
export(float) var walkTimeBig
var chaseCools : float
var resetChaseCools : float

#Make the enemies not aim directly at the player(more natural movement?)
export(float) var aimOffset
export(float) var aimOffsetTimer
var curAimOffsetTimer : float
var curAimOffset : float

	
func _ready():
	add_to_group("enemies")
	#params: name, blend, play speed
	anim.play("move", 1, 2)
	
	rotation_degrees = rand_range(0, 360)
	
	chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _physics_process(delta):
	if player == null:
		return
		
	if attackCools > 0:
		attackCools -= delta
		
	if curAimOffsetTimer > 0:
		curAimOffsetTimer -= delta
		
	if curAimOffsetTimer <= 0:
		curAimOffsetTimer = aimOffsetTimer
		curAimOffset = rand_range(-aimOffset, aimOffset)
		
	match (curState):
		States.idle:
			Idle(delta)
		States.patrol:
			Patrol(delta)
		States.chase:
			Chase(delta)
		States.attack:
			Attack()
		States.retreat:
			Retreat(delta)
		States.death:
			Death()
	
	#if inSight:
	#	var vec_to_player = player.global_position - global_position
	#	vec_to_player = vec_to_player.normalized()
	#	global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
	#	move_and_collide(vec_to_player * spd * delta)
 
	if raycast != null and raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player" and player.iframes <= 0 and attackCools <= 0:
			#print("Hitting player")
			attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
			coll.Damage(atk)
 
func Patrol(d):
	pass
	
func Idle(d):
	pass
	
func Retreat(d):
	pass
	
func Death():
	pass
	
func Attack():
	pass

func Chase(d):
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		move_and_collide(vec_to_player * spd * d)

func SwitchState(newState):
	curState = newState

func Damage(amt):
	hp -= amt
	
	if hp <= 0:
		kill()

func kill():
	queue_free()
 
func set_player(p):
	player = p

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)


#func _on_Head_body_entered(body):
	#Damage(body.atk / 3)

func ChangeState(newState):
	curState = newState

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true
		ChangeState(States.chase)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		ChangeState(States.patrol)
		inSight = false
