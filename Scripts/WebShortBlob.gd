extends Area2D

@export var hp: float = 1.0
@export var atk: float = 1.0
var lowDmgLimit : float
@export var lowDmgPercent: float
@export var damageFalloff: bool = false
@export var speedFalloff: bool = false
@export var falloffAmt: float = 3.0
var curAtk : float
var speed = 75.0
var startSpd = 75.0
@export var spdSlow : float = 50
@export var spdFast : float = 100
@export var speedupRate: float = 5.0
@export var slowdownRate: float = 5.0
var desiredSpd : float

var damaged = false

@export var knockback: float

@export var shrink: bool = false
@export var shrinkRate: float = 5.0
@export var scaledRate: float = 5.0
@export var scaledRate2: float = 5.0
var startScale

@onready var timer = $Timer

@export var hitString = ""
@export var spawnsObj =  false
@export var objToSpawn: PackedScene
@export var spawnsSecondObj =  false
@export var secondObj: PackedScene

@export var dedDir : bool = true

#var velocity = Vector2()

func _ready():
	lowDmgLimit = atk * lowDmgPercent
	curAtk = atk
	
	startScale = Vector2(scale.x, scale.y)
	
func start(pos, dir, acc):
	damaged = false
	desiredSpd = randf_range(spdSlow, spdFast)
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
	startSpd = randf_range(spdSlow, spdFast)
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
	var o = objToSpawn.instantiate()
	o.global_position = global_position
	get_tree().current_scene.add_child(o)

func SpawnSecondObj():
	var o = secondObj.instantiate()
	o.global_position = global_position
	get_tree().current_scene.add_child(o)

func _on_Timer_timeout():
	Disable()


func _on_DisableTimer_timeout():
	shrink = true
