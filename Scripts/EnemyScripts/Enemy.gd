extends KinematicBody2D

export(float) var maxHp = 4
var hp = 4
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

var blood = load("res://Scenes/Particles/Blood.tscn")

#Current stun time
var curStun = 0.0
#How long we're stunned
export(float) var stunTime = 7.0
#How many hits we're at currently
var stunDur = 0.0
#How many hits we take before we get stunned
export(float) var stunThreshold = 3.0
#Stun particles
export(PackedScene) var stunParts

export(float) var flashMinDmg = 5.0

#procedural animation stuff
onready var leg = $Legs/Leg
onready var leg2 = $Legs/Leg2
onready var leg3 = $Legs/Leg3
onready var leg4 = $Legs/Leg4
onready var leg5 = $Legs/Leg5
onready var leg6 = $Legs/Leg6
onready var leg7 = $Legs/Leg7
onready var leg8 = $Legs/Leg8
onready var legUpd = $LegUpdaters/LegUpd
onready var legUpd2 = $LegUpdaters/LegUpd2
onready var legUpd3 = $LegUpdaters/LegUpd3
onready var legUpd4 = $LegUpdaters/LegUpd4
onready var legUpd5 = $LegUpdaters/LegUpd5
onready var legUpd6 = $LegUpdaters/LegUpd6
onready var legUpd7 = $LegUpdaters/LegUpd7
onready var legUpd8 = $LegUpdaters/LegUpd8

var upd1 : Vector2
var upd2 : Vector2
var upd3 : Vector2
var upd4 : Vector2
var upd5 : Vector2
var upd6 : Vector2
var upd7 : Vector2
var upd8 : Vector2

export var maxLegDist : float = 2

export(float) var closestDistance = 10.0
export(float) var lookAtSpd = 10.0

#Status effects
var inFire : bool = false
export(float) var fireDmg = 1.75

func _ready():
	Setup()
	
func Animate():
	pass
	
func _process(delta):
	Animate()
	
func Setup():
	if legUpd != null:
		upd1 = legUpd.global_position
	if legUpd2 != null:
		upd2 = legUpd2.global_position
	if legUpd3 != null:
		upd3 = legUpd3.global_position
	if legUpd4 != null:
		upd4 = legUpd4.global_position
	if legUpd5 != null:
		upd5 = legUpd5.global_position
	if legUpd6 != null:
		upd6 = legUpd6.global_position
	if legUpd7 != null:
		upd7 = legUpd7.global_position
	if legUpd8 != null:
		upd8 = legUpd8.global_position
	
	hp = maxHp
	curState = States.idle
	set_player()
	add_to_group("enemies")
	#params: name, blend, play speed
	
	if (anim != null):
		anim.play("idle", 1, 2)
	
	rotation_degrees = rand_range(0, 360)
	
	chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _physics_process(delta):
	if player == null:
		return
		
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if curAimOffsetTimer > 0:
		curAimOffsetTimer -= delta
		
	if curAimOffsetTimer <= 0:
		curAimOffsetTimer = aimOffsetTimer
		curAimOffset = rand_range(-aimOffset, aimOffset)
		
	if curStun > 0:
		curStun -= delta
		#Stop enemy from moving or attacking
		
	if stunDur >= stunThreshold:
		
		#Spawn particles
		var s = stunParts.instance()
		s.emitting = true
		get_tree().current_scene.add_child(s)
		s.global_position = global_position
		s.get_node("Timer").wait_time = stunTime
		
		curStun = stunTime
		stunDur = 0
		
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
			coll.Damage(atk, coll.global_position)
			
	if inFire:
		FireDamage()
 
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
	if curStun <= 0:
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		#global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
		global_rotation = lerp_angle(global_rotation, atan2(vec_to_player.y, vec_to_player.x) + 89.5, lookAtSpd * d)
	
		var dis = global_position.distance_to(player.global_position)
		if dis >= closestDistance:
			move_and_collide(vec_to_player * spd * d)

func SwitchState(newState):
	curState = newState

func Damage(amt):
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator" and amt >= flashMinDmg:
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
	hp -= amt
	
	if hp <= 0:
		kill()

func FireDamage():
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator":
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
	hp -= fireDmg
	
	if hp <= 0:
		kill()

func Knockback(kick, dir):
	move_and_collide(dir * kick)

func SpawnBlood():
	#print("Spawned by: " + self.name)
	#blood particles
	var blood_instance = blood.instance()
	blood_instance.emitting = true
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	if (player != null):
		blood_instance.rotation = global_position.angle_to_point(player.global_position)
	#blood_instance.emitting = true
	pass
	
#func _process(delta):
#	if leg != null and legUpd != null:
#		leg.step(legUpd.global_position)
#	if leg2 != null and legUpd2 != null:
#		leg2.step(legUpd2.global_position)
#	if leg3 != null and legUpd3 != null:
#		leg3.step(legUpd3.global_position)
#	if leg4 != null and legUpd4 != null:
#		leg4.step(legUpd4.global_position)

func kill():
	SpawnBlood()
	queue_free()
 
func set_player():
	#player = p
	player = get_node("/root/World/Player") 

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

#func _on_Head_body_entered(body):
	#Damage(body.atk / 3)
	
func Stun(amt):
	if curStun <= 0:
		stunDur += amt
		
		print(stunDur)

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
