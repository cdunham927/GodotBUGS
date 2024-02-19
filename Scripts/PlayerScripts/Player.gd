extends KinematicBody2D

#HP
export(float) var maxHp = 100.0
var hp = 100

#Speed vars
var curSpd
var spdToLerpTo
export var spdLerpSpd = 50
export var regSpd = 300
export var forwardSpd = 300
export var backwardSpd = 300
export var sideSpd = 300

#Boosting
export var boostSpd = 500
var boostTimer : float = 0
var curBoostTimer : float = 0
export(float) var timeBetweenBoosts
var boostTime : float = 1
var boosting : bool = false

#Stamina vars
var stamina : float = 0
export(float) var maxStamina
export(float) var staminaDecAmt
export(float) var staminaRecAmt


#UI
export(float) var lerpSpd = 15
onready var healthbar = get_node("/root/World/UI/Health")
onready var staminabar = get_node("/root/World/UI/Stamina")

export var iframesTime : float = 0.3
var iframes : float = 0

var move_vec : Vector2

func _ready():
	hp = maxHp
	stamina = maxStamina
	#yield(get_tree(), "idle_frame")
	healthbar.value = maxHp
	healthbar.max_value = maxHp
	staminabar.max_value = maxStamina
	staminabar.value = maxStamina
	curSpd = regSpd
	#SetPlayer()
	
	
#func SetPlayer():
	#get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1

	move_vec = move_vec.normalized()
	
# warning-ignore:return_value_discarded
	move_and_collide(move_vec * curSpd * delta)
	
	#var lastMove = 
	if Input.is_action_just_pressed("sprint") and boostTimer <= 0:
		Boost()
		
	if boostTimer > 0:
		boostTimer -= delta
	
	if boosting:
		spdToLerpTo = boostSpd
		
	if curBoostTimer <= 0:
		boosting = 0
	
	if Input.is_action_pressed("sprint") and stamina > 0 and !boosting:
		stamina -= delta * staminaDecAmt
		spdToLerpTo = forwardSpd
	if Input.is_action_pressed("sprint") == false and !boosting:
		spdToLerpTo = regSpd
		stamina += delta * staminaRecAmt
	
	if iframes > 0:
		iframes -= delta
		
	curSpd = lerp(curSpd, spdToLerpTo, delta * spdLerpSpd)
	healthbar.value = lerp(healthbar.value, hp, lerpSpd * delta)
	staminabar.value = lerp(staminabar.value, stamina, lerpSpd * delta)
	
	#Hit with raycast, use for... sniper or laser?
	#if Input.is_action_just_pressed("shoot"):
	#	var coll = raycast.get_collider()
	#	if raycast.is_colliding() and coll.has_method("kill"):
	#		coll.kill()

func Boost():
	#move_and_collide(move_vec * boostSpd)
	boostTimer = timeBetweenBoosts

func Damage(amt):
	hp -= amt
	iframes = iframesTime
	
	if hp <= 0:
		Kill()
		
func Kill():
	#get_tree().reload_current_scene()
	#queue_free()
	pass
