extends Area2D

export(float) var hp = 250
 
var player = null
var inSight : bool = false

export(int) var spawnAmount = 5
 
export var enemy: PackedScene

var hasSpawned = false
onready var anim = $AnimationPlayer
var blood = load("res://Scenes/Blood.tscn")
	
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
	#SpawnBlood()
	if !hasSpawned:
		for i in spawnAmount:
			var e = enemy.instance()
			e.Setup()
			get_tree().current_scene.add_child(e)
			var randX = rand_range(-2, 2)
			var randY = rand_range(-2, 2)
			e.global_position = global_position + Vector2(randX, randY)
			hasSpawned = true
			pass
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true
		$Timer.start()


func _on_Area2D_body_exited(body):
	#if body.name == "Player":
		#inSight = false
		pass


func _on_Timer_timeout():
	kill()
	pass # Replace with function body.
