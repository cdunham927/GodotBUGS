extends KinematicBody2D

#HP
export(float) var maxHp = 100.0
var hp = 100

#Stamina vars
var stamina : float = 0
export(float) var maxStamina
export(float) var boostStaminaVal = 15.0
export(float) var staminaDecAmt
export(float) var staminaRecAmt

#Speed vars
var curSpd
export var spdToLerpTo = 50.0
export var spdLerpSpd = 50.0
var curLerpSpd
#export var boostLerpSpd = 50
export var regSpd = 300
export var forwardSpd = 300
export var backwardSpd = 300
export var sideSpd = 300

#Boosting
export var boostSpd = 500
var boostTimer : float = 0
var curBoostTimer : float = 0
export(float) var timeBetweenBoosts
export(float) var timeWeBoost
var boosting : bool = false

#UI
export(float) var lerpSpd = 15.0
onready var healthbar = get_node("/root/World/UI/Health")
onready var staminabar = get_node("/root/World/UI/Stamina2/Stamina")

export var iframesTime : float = 0.3
var iframes : float = 0

var move_vec : Vector2
var boost_vec : Vector2

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
	
	#var lastMove = 
		
	if curBoostTimer > 0:
		curBoostTimer -= delta
		
	if boostTimer > 0:
		boostTimer -= delta
	
	if boosting:
		spdToLerpTo = boostSpd
		
	#if curBoostTimer <= 0:
	#	boosting = false
	
	if curBoostTimer <= 0:
		boost_vec = Vector2(0, 0)
	
	#curLerpSpd = boostLerpSpd if boosting == true else spdLerpSpd
	curLerpSpd = spdLerpSpd
	boosting = true if curBoostTimer > 0 else false
	
	if (move_vec.x != 0 or move_vec.y != 0):
		if Input.is_action_just_pressed("sprint") and boostTimer <= 0 and stamina >= boostStaminaVal:
			Boost()
		
		if Input.is_action_pressed("sprint") and stamina > 0 and !boosting:
			stamina -= delta * staminaDecAmt
			spdToLerpTo = forwardSpd
		if Input.is_action_pressed("sprint") == false and !boosting:
			spdToLerpTo = regSpd
			#Restore stamina
			if stamina < maxStamina:
				stamina += delta * staminaRecAmt
	
		curSpd = lerp(curSpd, spdToLerpTo, delta * curLerpSpd)
	else:
		spdToLerpTo = 0
		curSpd = 0
	
	if iframes > 0:
		iframes -= delta

	healthbar.value = lerp(healthbar.value, hp, lerpSpd * delta)
	staminabar.value = lerp(staminabar.value, stamina, lerpSpd * delta)
	
	if staminabar.value > boostStaminaVal:
		pass
	
	#if Engine.is_editor_hint() == true:
	#	print("In editor")
	#	pass
	
	#Hit with raycast, use for... sniper or laser?
	#if Input.is_action_just_pressed("shoot"):
	#	var coll = raycast.get_collider()
	#	if raycast.is_colliding() and coll.has_method("kill"):
	#		coll.kill()
	
# warning-ignore:return_value_discarded
	if boosting == false:
		move_and_collide(move_vec * curSpd * delta)
	if boost_vec != Vector2(0, 0):
		 move_and_collide(boost_vec * boostSpd * delta)

func Boost():
	#move_and_collide(move_vec * boostSpd)
	#boosting = true
	stamina -= boostStaminaVal
	boost_vec = move_vec
	boostTimer = timeBetweenBoosts + timeWeBoost
	curBoostTimer = timeWeBoost

func Damage(amt):
	if iframes <= 0:
		hp -= amt
		iframes = iframesTime
	
	if hp <= 0:
		Kill()

func Heal(amt):
	#Make sure we dont overheal
	var totHp = amt + hp
	if totHp > maxHp:
		hp = maxHp
	else:
		hp = totHp
	
func Kill():
	#get_tree().reload_current_scene()
	#queue_free()
	pass
