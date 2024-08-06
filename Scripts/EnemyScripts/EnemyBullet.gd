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
var startScale

onready var timer = $Timer

#var velocity = Vector2()

func _ready():
	lowDmgLimit = atk * lowDmgPercent
	curAtk = atk
	
	startScale = Vector2(scale.x, scale.y)
	
func start(pos, dir, acc):
	damaged = false
	
	desiredSpd = rand_range(spdSlow, spdFast)
	rotation = dir
	rotation_degrees += rand_range(-acc, acc)
	global_position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position += transform.y * speed * delta
	
	if !speedFalloff:
		speed = lerp(speed, desiredSpd, delta * speedupRate)
	
	if speedFalloff:
		speed = lerp(speed, 0, delta * slowdownRate)
	
	if damageFalloff:
		curAtk = lerp(curAtk, lowDmgLimit, delta * falloffAmt)
		
	if speed <= 0:
		Disable()
	
	#Biggy smol
	if timer != null:
		if !shrink and !speedFalloff:
			scale.x += scaledRate * delta
			scale.y += scaledRate * delta
	
		if !shrink and speedFalloff and scale.x >= startScale.x:
			scale.x -= shrinkRate * delta
			scale.y -= shrinkRate * delta
		
		#Shrink to destroy
		if shrink:
			scale.x -= delta * shrinkRate
			scale.y -= delta * shrinkRate
			if  scale.x <= 0.05:
				queue_free()
	
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
		body.Damage(curAtk, global_position)
		curAtk -= 1
		hp -= 1
		if hp <= 0:
			Disable()


func _on_Timer_timeout():
	speedFalloff = true


func _on_DisableTimer_timeout():
	shrink = true
