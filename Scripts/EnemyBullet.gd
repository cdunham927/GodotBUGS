extends Area2D

export var poolName = ""
onready var bulletPool = get_node("/root/World/" + poolName)
onready var world = get_node("/root/World")

export(float) var hp = 1
export(float) var atk = 1
var curAtk : float
var speed = 75
export var spdSlow : float = 50
export var spdFast : float = 100

#var velocity = Vector2()

func RandomizeSpeed():
	speed = rand_range(spdSlow, spdFast)

func _ready():
	curAtk = atk
	
func start(pos, dir, acc):
	speed = rand_range(spdSlow, spdFast)
	rotation = dir
	rotate(rand_range(-acc, acc))
	position = pos

func _physics_process(delta):
	position += transform.y * speed * delta
	
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	Disable()
	
func Disable():
	world.remove_child(self)
	bulletPool.add_child(self)
	self.hide()

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		body.Damage(curAtk)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()
