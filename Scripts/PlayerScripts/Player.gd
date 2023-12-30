extends KinematicBody2D

export(float) var maxHp = 100
var hp = 100
var curSpd
export var spd = 300
export var runSpd = 500
var stamina
export(float) var maxStamina
export(float) var staminaDecAmt
export(float) var staminaRecAmt
onready var healthbar = get_node("/root/World/UI/Health")
onready var staminabar = get_node("/root/World/UI/Stamina")

export var iframesTime : float = 0.3
var iframes : float = 0

export var lerpSpd : float = 10
 
func _ready():
	hp = maxHp
	stamina = maxStamina
	#yield(get_tree(), "idle_frame")
	healthbar.value = maxHp
	healthbar.max_value = maxHp
	staminabar.max_value = maxStamina
	staminabar.value = maxStamina
	curSpd = spd
	get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_and_collide(move_vec * curSpd * delta)
	
	if Input.is_action_pressed("sprint") and stamina > 0:
		stamina -= delta * staminaDecAmt
		curSpd = runSpd
	if Input.is_action_pressed("sprint") == false:
		curSpd = spd
		stamina += delta * staminaRecAmt
	
	if iframes > 0:
		iframes -= delta
		
	healthbar.value = lerp(healthbar.value, hp, lerpSpd * delta)
	staminabar.value = lerp(staminabar.value, stamina, lerpSpd * delta)
		
	#Hit with raycast, use for... sniper or laser?
	#if Input.is_action_just_pressed("shoot"):
	#	var coll = raycast.get_collider()
	#	if raycast.is_colliding() and coll.has_method("kill"):
	#		coll.kill()

func Damage(amt):
	hp -= amt
	iframes = iframesTime
	
	if hp <= 0:
		Kill()
		
func Kill():
	#get_tree().reload_current_scene()
	#queue_free()
	pass
