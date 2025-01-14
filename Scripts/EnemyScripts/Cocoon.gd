extends Area2D

export(float) var maxHp = 250
var hp = 250
 
var player = null
var inSight : bool = false

export(int) var spawnAmount = 5
 
export var enemy: PackedScene

var hasSpawned = false
onready var anim = $AnimationPlayer
var blood = load("res://Scenes/Particles/Blood.tscn")
	
onready var src = get_node("/root/World/EnemySrc")
export(String) var soundName = "Splat"
var snd

var hasAdded = false

func _ready():
	snd = load("res://Audio/SFX/" + soundName + ".mp3")
	if get_parent().numSpiders != null:
		get_parent().numSpiders += 1
	else:
		get_parent().get_parent().numSpiders += 1
	hp = maxHp
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
	if anim != null and anim.current_animation == name:
		return
		anim.play(name)
	
func Damage(amt):
	if anim != null:
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
	
func _process(delta):
	#if inSight and !hasSpawned:
	#	$Timer.start()
	
	if inSight:
		$ShakeAndGlow.spd += delta * $ShakeAndGlow.spdIncrease
	pass
	
func SpawnEnemy():
	var e = enemy.instance()
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
	
export(float) var pitchLow = 0.8
export(float) var pitchHigh = 1.3
func play_sound(s = snd, pitched = false):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		src.pitch_scale = rand_range(pitchLow, pitchHigh)
	src.stream = s
	src.play()

func kill():
	play_sound(snd, true)
	if !hasAdded:
		hasAdded = true
		if get_parent().numSpiders != null:
			get_parent().numSpiders -= 1
		else:
			get_parent().get_parent().numSpiders -= 1
	SpawnBlood()
	queue_free()
	
func spawn_and_kill():
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
			
		if !hasAdded:
			hasAdded = true
			if get_parent().numSpiders != null:
				get_parent().numSpiders -= 1
			else:
				get_parent().get_parent().numSpiders -= 1
				
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		inSight = true
		$Timer.start()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		#inSight = false
		pass


func _on_Timer_timeout():
	spawn_and_kill()
	pass # Replace with function body.
