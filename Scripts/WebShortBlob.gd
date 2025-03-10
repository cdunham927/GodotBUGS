extends Area2D

export(float) var hp = 1.0
export(float) var atk = 1.0
var lowDmgLimit : float
export(float) var lowDmgPercent
export(bool) var damageFalloff = false
export(bool) var speedFalloff = false
export(float) var falloffAmt = 3.0
var curAtk : float
var speed = 75.0
var startSpd = 75.0
export var spdSlow : float = 50
export var spdFast : float = 100
export(float) var speedupRate = 5.0
export(float) var slowdownRate = 5.0
var desiredSpd : float

var damaged = false

export(float) var knockback

export(bool) var shrink = false
export(float) var shrinkRate = 5.0
export(float) var scaledRate = 5.0
export(float) var scaledRate2 = 5.0
var startScale

onready var timer = $Timer

export var hitString = ""
export var spawnsObj =  false
export(PackedScene) var objToSpawn
export var spawnsSecondObj =  false
export(PackedScene) var secondObj

export var dedDir : bool = true

#var velocity = Vector2()

func _ready():
	lowDmgLimit = atk * lowDmgPercent
	curAtk = atk
	
	startScale = Vector2(scale.x, scale.y)
	
func start(pos, dir, acc):
	damaged = false
	desiredSpd = rand_range(spdSlow, spdFast)
	rotation = dir
	if dedDir:
		rotation_degrees = acc
	else:
		rotation_degrees += acc
	global_position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position += transform.y * desiredSpd * delta

func RandomizeSpeed():
	startSpd = rand_range(spdSlow, spdFast)
	speed = startSpd
	
#func _on_VisibilityNotifier2D_viewport_exited(viewport):
#	Disable()
	
func Disable():
#	world.remove_child(self)
#	bulletPool.add_child(self)
	if spawnsObj:
		SpawnObj()
	if spawnsSecondObj:
		SpawnSecondObj()
	queue_free()
	
func _on_Bullet_body_entered(body):
	if body.name == "Player":
		body.Damage(curAtk, global_position)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()

func SpawnObj():
	var o = objToSpawn.instance()
	o.global_position = global_position
	get_tree().current_scene.add_child(o)

func SpawnSecondObj():
	var o = secondObj.instance()
	o.global_position = global_position
	get_tree().current_scene.add_child(o)

func _on_Timer_timeout():
	Disable()


func _on_DisableTimer_timeout():
	shrink = true
