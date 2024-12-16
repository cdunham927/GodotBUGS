extends Area2D

export(float) var hp = 4
 
#onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

export var maxToSpawn : int = 1
export(float) var spawnTimeLow
export(float) var spawnTimeBig
var curSpawns : float
 
#Stuff for projectile enemies
export(float) var spawnChanceA = 0.25
export var dungBeetle: PackedScene
export(float) var spawnChanceB = 0.5
export var beetleA: PackedScene
export(float) var spawnChanceC = 0.75
export var beetleB: PackedScene
export(float) var spawnChanceD = 1
export var stagBeetle: PackedScene
#export var enemyList = [ true ]

#export var poolName = ""
#onready var bulletPool = get_node("/root/World/" + poolName)
#onready var world = get_node("/root/World")
#export(float) var accuracy

export var shrinkAmt = 0.01

export(bool) var paused = false
export var spawnsOnDeath = false
var hasSpawned = false
export var deathEnemy: PackedScene

onready var anim = $AnimationPlayer

var blood = load("res://Scenes/Blood.tscn")

var gc
	
func _ready():
	hasSpawned = false
	add_to_group("enemies")
	player = get_node("/root/World/Player") 
	gc = get_parent()
	
	shrinkAmt = (hp / 250000000)
	#params: name, blend, play speed
	#anim.play("move", 1, 2)
	
	#rotation_degrees = rand_range(0, 360)
	
	#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	#resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	#attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _process(delta):
	#Check if player is in range too
	if inSight and !paused:
		if curSpawns > 0:
			curSpawns -= delta
		
		if curSpawns <= 0:
			curSpawns = rand_range(spawnTimeLow, spawnTimeBig)
		
			var toSpawnNow = (randi() % maxToSpawn)
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
		var e = dungBeetle.instance()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	elif i < spawnChanceD:
		var e = stagBeetle.instance()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	elif i < spawnChanceB:
		var e = beetleA.instance()
		e.Setup()
		get_tree().current_scene.add_child(e)
		e.global_position = global_position
	else:
		var e = beetleB.instance()
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
		var e = deathEnemy.instance()
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
