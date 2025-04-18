extends Area2D

@export var maxHp: float = 250
var hp
 
var player = null
var inSight : bool = false

@export var spawnAmount: int = 5
 
@export var enemy: PackedScene

var hasSpawned = false
@onready var anim = $AnimationPlayer
var blood = load("res://Scenes/Particles/Blood.tscn")

@onready var hpBar = $UIHolder/HP

@export var lerpSpd: float = 15.0;
	
func _ready():
	hp = maxHp
	hasSpawned = false
	add_to_group("enemies")
	player = get_node("/root/World/Player") 
	
	hpBar.max_value = maxHp
	hpBar.value = hp
	#params: name, blend, play speed
	#anim.play("move", 1, 2)
	
	#rotation_degrees = rand_range(0, 360)
	
	#chaseCools = rand_range(walkTimeSmall, walkTimeBig)
	#resetChaseCools = rand_range(chaseCooldownSmall, chaseCooldownBig)
	#attackCools = rand_range(timeBetweenAttacksSmall, timeBetweenAttacksBig)
 
func _process(delta):
	hpBar.value = lerp(hpBar.value, hp, lerpSpd * delta)

func play_anim(name):
	if anim != null and anim.current_animation == name:
		return
		anim.play(name)
	
func Damage(amt):
	if anim != null:
		play_anim("Hit")
	#BloodSpray()
	hp -= amt
	
	if hp <= 0:
		kill()
	
func SpawnEnemy():
	var e = enemy.instantiate()
	e.Setup()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position

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
	
func kill():
	get_parent().deadHills += 1
	SpawnBlood()
	queue_free()
	
