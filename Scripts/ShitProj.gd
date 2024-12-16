extends Area2D

export(float) var hp = 1.0
export(float) var atk = 1.0
var curAtk : float
var speed = 75.0
export var spdSlow : float = 50
export var spdFast : float = 100

var damaged = false

onready var timer = $Timer

export var hitString = ""
export var shit : PackedScene

#var velocity = Vector2()

func _ready():
	$SpawnTimer.wait_time = $Timer.wait_time / 2
	curAtk = atk
	speed = rand_range(spdSlow, spdFast)
	
func start(pos, dir, acc):
	damaged = false
	rotation = dir
	rotation_degrees += rand_range(-acc, acc)
	global_position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position += transform.y * speed * delta
	
func Disable():
	queue_free()
	
func _on_Timer_timeout():
	Disable()
	
func _on_SpawnTimer_timeout():
	#Spawn shit
	var s = shit.instance()
	s.global_position = global_position
	s.rotation_degrees = rotation_degrees
	get_tree().current_scene.add_child(s)
