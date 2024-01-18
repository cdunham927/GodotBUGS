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
	
func start(pos, dir):
	bulletPool.remove_child(self)
	world.add_child(self)
	
	speed = rand_range(spdSlow, spdFast)
	rotation = dir
	position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position -= transform.y * speed * delta
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	velocity = velocity.bounce(collision.normal)
		
		#if collision.is_in_group("enemies"):
		#	collision.Damage(curAtk)
		#	curAtk -= 1
		#	hp -= 1
		#	if hp <= 0:
		#		Disable()
		#if collision.is_in_group("turtle"):
		#	collision.Damage(curAtk / 3)
		#	curAtk -= 1
		#	hp -= 1
		#	if hp <= 0:
		#		Disable()
		
		
		#hp -= 1
		#if hp <= 0:
		#	Disable()
		
		#if collision.collider.has_method("hit"):
		#	collision.collider.hit()
	
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	Disable()
	
func Disable():
	world.remove_child(self)
	bulletPool.add_child(self)
	self.hide()

func _on_Bullet_body_entered(body):
	#print(body.name)
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
