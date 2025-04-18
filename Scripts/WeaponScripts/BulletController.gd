extends Area2D

@export var hp: float = 1.0
@export var atk: float = 1.0
var lowDmgLimit : float
@export var lowDmgPercent: float
@export var damageFalloff: bool = false
@export var falloffAmt: float = 3.0
var curAtk : float
var speed = 75.0
var startSpd = 75.0
@export var spdSlow : float = 50
@export var spdFast : float = 100

var damaged = false

@export var knockback: float

@export var bloodSpray: PackedScene

#Spark hit particles
@export var sparkParts: PackedScene

func RandomizeSpeed():
	startSpd = randf_range(spdSlow, spdFast)
	speed = startSpd

func _ready():
	lowDmgLimit = atk * lowDmgPercent
	curAtk = atk
	
func start(pos, dir, acc):
	damaged = false
	
	speed = randf_range(spdSlow, spdFast)
	rotation = dir
	rotation_degrees += randf_range(-acc, acc)
	global_position = pos
	#velocity = Vector2(0, speed).rotated(rotation)

func _physics_process(delta):
	position -= transform.y * speed * delta
	
	if damageFalloff:
		speed = lerp(speed, 0, delta * falloffAmt)
		curAtk = lerp(curAtk, lowDmgLimit, delta * falloffAmt)
		
	if speed <= 0:
		Disable()
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
	
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	Disable()
	
func Disable():
	#print("End damage: ", curAtk)
#	world.remove_child(self)
#	bulletPool.add_child(self)
	queue_free()
	#self.hide()
	
func SpawnPart(pos):
	#Spawn particles
	var s = sparkParts.instantiate()
	s.emitting = true
	get_node("/root/World").add_child(s)
	s.global_position = pos
	#s.get_node("Timer").wait_time = stunTime

func _on_Bullet_body_entered(body):
	#print(body.name)
	if body.is_in_group("Wall"):
		SpawnPart(global_position)
		Disable()
	if body.is_in_group("enemies") and !damaged:
		#print("Damaged by: ", curAtk)
		if body.has_method("Knockback"):
			body.Knockback(knockback, -transform.y)
		if body.has_method("Damage"):
			body.Damage(curAtk)
		#curAtk -= 1
		hp -= 1
		damaged = true
		SpawnBlood()
		if hp <= 0:
			Disable()


func _on_Bullet_area_entered(area):
	if area.is_in_group("turtle"):
		#deflect bullet
		rotation_degrees += randf_range(140, 210)
		if !damaged:
			#print("Damaged by: ", curAtk / 4)
			area.get_parent().Damage(curAtk / 4)
			SpawnBlood()
		
			#curAtk -= 1
			hp -= 1
			damaged = true
		if hp <= 0:
			Disable()
	if area.is_in_group("Exploder"):
		#deflect bullet
		#rotation_degrees += rand_range(140, 210)
		if !damaged:
			#print("Damaged by: ", curAtk / 4)
			#area.get_parent().Damage(curAtk / 4)
			SpawnBlood()
		
			#curAtk -= 1
			hp -= 999
			damaged = true
			area.get_parent().Explode()
		if hp <= 0:
			Disable()
	#Hit static enemies
	if area.is_in_group("enemies") and !damaged:
		if area.has_method("Knockback"):
			area.Knockback(knockback, -transform.y)
		if area.has_method("Damage"):
			area.Damage(curAtk)
		#curAtk -= 1
		hp -= 1
		SpawnBlood()
		damaged = true
		if hp <= 0:
			Disable()

func SpawnBlood():
	#print("Spawned by: " + self.name)
	#blood particles
	var blood_instance = bloodSpray.instance()
	blood_instance.emitting = true
	get_node("/root/World").add_child(blood_instance)
	blood_instance.global_position = global_position
	#if (player != null):
	#	blood_instance.rotation = global_position.angle_to_point(player.global_position)
	#blood_instance.emitting = true
	#pass

func _on_Timer_timeout():
	Disable()
