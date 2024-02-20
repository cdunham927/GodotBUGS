extends KinematicBody2D

export(float) var hp = 4
 
#onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

export var maxToSpawn : int = 1
export(float) var spawnTimeLow
export(float) var spawnTimeBig
var curSpawns : float
 
#Stuff for projectile enemies
export var enemy: PackedScene
#export var poolName = ""
#onready var bulletPool = get_node("/root/World/" + poolName)
#onready var world = get_node("/root/World")
#export(float) var accuracy

var blood = load("res://Scenes/Blood.tscn")
	
func _ready():
	add_to_group("enemies")
	#params: name, blend, play speed
	#anim.play("move", 1, 2)
	
	#rotation_degrees = rand_range(0, 360)
	
	#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	#resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	#attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _process(delta):
	#Check if player is in range too
	if inSight:
		if curSpawns > 0:
			curSpawns -= delta
		
		if curSpawns <= 0:
			curSpawns = rand_range(spawnTimeLow, spawnTimeBig)
		
			var toSpawnNow = (randi() % maxToSpawn)
			for i in toSpawnNow:
				SpawnEnemy()
	
func Damage(amt):
	BloodSpray()
	hp -= amt
	
	if hp <= 0:
		kill()

func Knockback(kick, dir):
	pass

func BloodSpray():
	#$BloodSpray.restart()
	#$BloodSpray.emitting = false
	
	#emit then stop emitting after 0.1 seconds or so
	#$BloodSpray.emitting = true
	#$BloodSpray/Timer.start()
	pass
	
func SpawnEnemy():
	var e = enemy.instance()
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
	SpawnBlood()
	queue_free()
 


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		inSight = false
