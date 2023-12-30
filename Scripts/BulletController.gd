extends Area2D

export var poolName = ""
onready var bulletPool = get_node("/root/World/" + poolName)
onready var world = get_node("/root/World")

export(float) var hp = 1
export(float) var atk = 1
var curAtk : float
export var speed = 75
export var spdSlow : float = 50
export var spdFast : float = 100

func RandomizeSpeed():
	speed = rand_range(spdSlow, spdFast)

func _ready():
	curAtk = atk

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	Disable()
	
func Disable():
	world.remove_child(self)
	bulletPool.add_child(self)
	self.hide()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.Damage(curAtk)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()
	if body.is_in_group("turtle"):
		body.Damage(curAtk / 3)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()
