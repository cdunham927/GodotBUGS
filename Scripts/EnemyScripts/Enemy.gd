extends CharacterBody2D

@export var paused: bool = false
@export var maxHp: float = 4
var hp = 4
@export var spd = 200
@export var atk = 5
 
@onready var raycast = $RayCast2D
@onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

enum States { idle, patrol, chase, attack, retreat, death }
var curState : int = States.idle

@export var timeBetweenAttacksSmall: float
@export var timeBetweenAttacksBig: float
var attackCools : float
 
@export var accuracy: float

@export var chaseCooldownSmall: float
@export var chaseCooldownBig: float
@export var walkTimeSmall: float
@export var walkTimeBig: float
var chaseCools : float
var resetChaseCools : float

#Make the enemies not aim directly at the player(more natural movement?)
@export var aimOffset: float
@export var aimOffsetTimer: float
var curAimOffsetTimer : float
var curAimOffset : float

var blood = load("res://Scenes/Particles/Blood.tscn")

#Current stun time
var curStun = 0.0
#How long we're stunned
@export var stunTime: float = 7.0
#How many hits we're at currently
var stunDur = 0.0
#How many hits we take before we get stunned
@export var stunThreshold: float = 3.0
#Stun particles
@export var stunParts: PackedScene

@export var flashMinDmg: float = 5.0

#procedural animation stuff
@onready var leg = $Legs/Leg
@onready var leg2 = $Legs/Leg2
@onready var leg3 = $Legs/Leg3
@onready var leg4 = $Legs/Leg4
@onready var leg5 = $Legs/Leg5
@onready var leg6 = $Legs/Leg6
@onready var leg7 = $Legs/Leg7
@onready var leg8 = $Legs/Leg8
@onready var legUpd = $LegUpdaters/LegUpd
@onready var legUpd2 = $LegUpdaters/LegUpd2
@onready var legUpd3 = $LegUpdaters/LegUpd3
@onready var legUpd4 = $LegUpdaters/LegUpd4
@onready var legUpd5 = $LegUpdaters/LegUpd5
@onready var legUpd6 = $LegUpdaters/LegUpd6
@onready var legUpd7 = $LegUpdaters/LegUpd7
@onready var legUpd8 = $LegUpdaters/LegUpd8

var upd1 : Vector2
var upd2 : Vector2
var upd3 : Vector2
var upd4 : Vector2
var upd5 : Vector2
var upd6 : Vector2
var upd7 : Vector2
var upd8 : Vector2

@export var maxLegDist : float = 2

@export var closestDistance: float = 10.0
@export var lookAtSpd: float = 10.0

#Status effects
var inFire : bool = false
@export var fireDmg: float = 1.75

@onready var src = get_node("/root/World/EnemySrc")
@onready var walkSrc = $Stream
@export var soundName: String = "Splat"
var snd

var walkSnd
@export var walkSoundName: String = "BugScuttle"
@export var soundNames = [ "BugScuttle",  "BugScuttle2", "BugScuttle3", "BugScuttle4" ]
@export var dmgSounds = [ "Squish",  "Squish2" ]
var dmgSndA
var dmgSndB
var soundsA
var soundsB
var soundsC
var soundsD
var playingWalk : bool = false

func _ready():
	#if soundNames.size() > 1:
	#	for i in soundNames:
	#		sounds[i] = load("res://Audio/SFX/" + soundNames[i] + ".wav")
	soundsA = load("res://Audio/SFX/" + soundNames[0] + ".wav")
	soundsB = load("res://Audio/SFX/" + soundNames[1] + ".wav")
	soundsC = load("res://Audio/SFX/" + soundNames[2] + ".wav")
	soundsD = load("res://Audio/SFX/" + soundNames[3] + ".wav")
	
	dmgSndA = load("res://Audio/SFX/" + dmgSounds[0] + ".wav")
	dmgSndB = load("res://Audio/SFX/" + dmgSounds[1] + ".wav")
	
	walkSnd = load("res://Audio/SFX/" + walkSoundName + ".wav")
	snd = load("res://Audio/SFX/" + soundName + ".mp3")
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
	
	rotation_degrees = randf_range(0, 360)
	
	chaseCools = randf_range(walkTimeSmall, walkTimeBig)
	resetChaseCools = randf_range(chaseCooldownSmall, chaseCooldownBig)
	attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _physics_process(delta):
	if paused:
		return
	
	if player == null:
		return
		
	if attackCools > 0 and curStun <= 0:
		attackCools -= delta
		
	if curAimOffsetTimer > 0:
		curAimOffsetTimer -= delta
		
	if curAimOffsetTimer <= 0:
		curAimOffsetTimer = aimOffsetTimer
		curAimOffset = randf_range(-aimOffset, aimOffset)
		
	if curStun > 0:
		curStun -= delta
		#Stop enemy from moving or attacking
		
	if stunDur >= stunThreshold:
		
		#Spawn particles
		var s = stunParts.instantiate()
		s.emitting = true
		add_child(s)
		#get_tree().current_scene.add_child(s)
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
			attackCools = randf_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
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
	if paused:
		return
		
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator" and amt >= flashMinDmg:
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
		
	hp -= amt
	play_random_dmg_sound(true)
	
	if hp <= 0:
		kill()

func FireDamage():
	if paused:
		return
		
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator":
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
		
	hp -= fireDmg
	play_random_dmg_sound(true)
	
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
	play_sound(snd, true)
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
	
@export var pitchLow: float = 0.6
@export var pitchHigh: float = 1.5
func play_sound(s = snd, pitched = false, soundSrc = src):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		soundSrc.pitch_scale = randf_range(pitchLow, pitchHigh)
	soundSrc.stream = s
	soundSrc.play()

func _on_WalkTimer_timeout():
	playingWalk = false

func play_random_sound(pitched = false, soundSrc = walkSrc):
	var randSnd = randi() % soundNames.size()
	#print(randSnd)
	if randSnd == 0:
		soundSrc.stream = soundsA
	elif randSnd == 1:
		soundSrc.stream = soundsB
	elif randSnd == 2:
		soundSrc.stream = soundsC
	else:
		soundSrc.stream = soundsD
	
	if pitched:
		soundSrc.pitch_scale = randf_range(pitchLow, pitchHigh)
	soundSrc.play()

func play_random_dmg_sound(pitched = false, soundSrc = src):
	var randSnd = randi() % dmgSounds.size()
	#print(randSnd)
	if randSnd == 0:
		soundSrc.stream = dmgSndA
	else:
		soundSrc.stream = dmgSndB
	
	if pitched:
		soundSrc.pitch_scale = randf_range(pitchLow, pitchHigh)
	soundSrc.play()
