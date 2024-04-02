extends Area2D

export(float) var hp = 1.0
export(float) var atk = 1.0
var lowDmgLimit : float
export(float) var lowDmgPercent
export(bool) var damageFalloff = false
export(float) var falloffAmt = 3.0
var curAtk : float
var speed = 75.0
var startSpd = 75.0
export var spdSlow : float = 50
export var spdFast : float = 100

var damaged = false

export(float) var knockback

#var velocity = Vector2()

func _ready():
	lowDmgLimit = atk * lowDmgPercent
	curAtk = atk
	
func start(pos, dir, acc):
	damaged = false
	
	speed = rand_range(spdSlow, spdFast)
	rotation = dir
	rotation_degrees += rand_range(-acc, acc)
	global_position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position += transform.y * speed * delta
	
	if damageFalloff:
		speed = lerp(speed, 0, delta * falloffAmt)
		curAtk = lerp(curAtk, lowDmgLimit, delta * falloffAmt)
		
	if speed <= 0:
		Disable()
#var velocity = Vector2()

func RandomizeSpeed():
	startSpd = rand_range(spdSlow, spdFast)
	speed = startSpd
	
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	Disable()
	
func Disable():
#	world.remove_child(self)
#	bulletPool.add_child(self)
	self.hide()

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		body.Damage(curAtk)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()
