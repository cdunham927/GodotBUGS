extends Area2D

@export var hp: float = 4
 
#onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

@export var maxToSpawn : int = 1
@export var spawnTimeLow: float
@export var spawnTimeBig: float
var curSpawns : float
 
#Stuff for projectile enemies
@export var enemy: PackedScene
#export var poolName = ""
#onready var bulletPool = get_node("/root/World/" + poolName)
#onready var world = get_node("/root/World")
#export(float) var accuracy

@export var paused: bool = false
@export var spawnsOnDeath = false
var hasSpawned = false
@export var deathEnemy: PackedScene

@onready var anim = $AnimationPlayer

var blood = load("res://Scenes/Particles/Blood.tscn")
	
func _ready():
	hasSpawned = false
	add_to_group("enemies")
	player = get_node("/root/World/Player") 
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
			curSpawns = randf_range(spawnTimeLow, spawnTimeBig)
		
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
	var e = enemy.instantiate()
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
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true


func _on_Area2D_body_exited(body):
	#if body.name == "Player":
		#inSight = false
		pass
