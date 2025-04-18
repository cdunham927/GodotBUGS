extends Area2D

@export var hp: float = 4
@export var maxHp: float = 4
@export var lowHpThreshold: float = 0.5
var lowerHp

@export var hpLerp: float = 2
@export var hpBGLerp: float = 7
 
#onready var anim = $AnimationPlayer
@onready var healthbar = get_node("/root/World/DungHeapUI/BossHpBG")
@onready var healthbarBG = get_node("/root/World/DungHeapUI/BossHpBG/BossHpActual")
 
var player = null
var inSight : bool = false

@export var maxToSpawn : int = 1
@export var lowHpMaxToSpawn : int = 1
@export var spawnTimeLow: float
@export var spawnTimeBig: float
@export var lowHpSpawnTimeLow: float
@export var lowHpSpawnTimeBig: float
var curSpawns : float
 
#Stuff for projectile enemies
@export var spawnChanceA: float = 0.25
@export var dungBeetle: PackedScene
@export var spawnChanceB: float = 0.5
@export var beetleA: PackedScene
@export var spawnChanceC: float = 0.75
@export var beetleB: PackedScene
@export var spawnChanceD: float = 1
@export var stagBeetle: PackedScene
#export var enemyList = [ true ]

#export var poolName = ""
#onready var bulletPool = get_node("/root/World/" + poolName)
#onready var world = get_node("/root/World")
#export(float) var accuracy

@export var shrinkAmt = 0.01

@export var paused: bool = false
@export var spawnsOnDeath = false
var hasSpawned = false
@export var deathEnemy: PackedScene

@onready var anim = $AnimationPlayer

var blood = load("res://Scenes/Blood.tscn")

var gc
	
func _ready():
	hp = maxHp
	lowerHp = maxHp * lowHpThreshold
	hasSpawned = false
	add_to_group("enemies")
	player = get_node("/root/World/Player") 
	gc = get_parent()
	
	shrinkAmt = (hp / 135000000)
	
	if healthbar != null:
		healthbar.value = maxHp
		healthbar.max_value = maxHp
	if healthbarBG != null:
		healthbarBG.value = maxHp
		healthbarBG.max_value = maxHp
	#params: name, blend, play speed
	#anim.play("move", 1, 2)
	
	#rotation_degrees = rand_range(0, 360)
	
	#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	#resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	#attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _process(delta):
	if healthbar != null:
		healthbar.value = lerp(healthbar.value, hp, hpLerp * delta)
	if healthbarBG != null:
		healthbarBG.value = lerp(healthbarBG.value, hp, hpBGLerp * delta)
	
	#Check if player is in range too
	if !paused:
		if curSpawns > 0:
			curSpawns -= delta
		
		if curSpawns <= 0:
			if hp < lowerHp:
				curSpawns = randf_range(lowHpSpawnTimeLow, lowHpSpawnTimeBig)
			else:
				curSpawns = randf_range(spawnTimeLow, spawnTimeBig)
			
			var toSpawnNow
			if hp < lowerHp:
				toSpawnNow = (randi() % lowHpMaxToSpawn)
			else:
				toSpawnNow = (randi() % maxToSpawn)
			for i in toSpawnNow:
				SpawnEnemy()

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)
	
func Damage(amt):
	play_anim("Hit")
	inSight = true
	BloodSpray()
	hp -= amt
	
	scale.x -= (amt * shrinkAmt)
	scale.y -= (amt * shrinkAmt)
	
	if hp <= 0:
		kill()

func BloodSpray():
	#$BloodSpray.restart()
	#$BloodSpray.emitting = false
	
	#emit then stop emitting after 0.1 seconds or so
	#$BloodSpray.emitting = true
	#$BloodSpray/Timer.start()
	pass
	
func SpawnEnemy():
	#Decide which enemy to spawn
	var i = randi()
	if i < spawnChanceA:
		var e = dungBeetle.instantiate()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	elif i < spawnChanceD:
		var e = stagBeetle.instantiate()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	elif i < spawnChanceB:
		var e = beetleA.instantiate()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	else:
		var e = beetleB.instantiate()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
		
func SpawnBlood():
	#blood particles
	var blood_instance = blood.instance()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	
	#blood_instance.rotation = global_position.angle_to_point(player.global_position)

func kill():
	#SpawnBlood()
	if spawnsOnDeath and !hasSpawned:
		var e = deathEnemy.instantiate()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
		hasSpawned = true
	gc.Victory()
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true


func _on_Area2D_body_exited(body):
	#if body.name == "Player":
		#inSight = false
		pass
