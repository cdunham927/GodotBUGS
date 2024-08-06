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
var controller_aim : Vector2
var boost_vec : Vector2

#Spark hit particles
export(PackedScene) var sparkParts

#Animation
onready var anim = $AnimationPlayer

#Status effects
var inFire : bool = false
export(float) var fireDmg = 1.75
export(float) var fireThreshold
var curFire : float = 0.0

func _ready():
	if healthbar == null:
		healthbar = get_node("/root/World2/UI/Health")
	if staminabar == null:
		staminabar = get_node("/root/World2/UI/Stamina2/Stamina")
	
	hp = maxHp
	stamina = maxStamina
	#yield(get_tree(), "idle_frame")
	if healthbar != null:
		healthbar.value = maxHp
		healthbar.max_value = maxHp
	if staminabar != null:
		staminabar.max_value = maxStamina
		staminabar.value = maxStamina
	curSpd = regSpd
	#SetPlayer()
	
#func SetPlayer():
	#get_tree().call_group("enemies", "set_player", self)

func _physics_process(delta):
	move_vec = Vector2()
	#if Input.is_action_pressed("move_up"):
	#	move_vec.y -= 1
	#if Input.is_action_pressed("move_down"):
	#	move_vec.y += 1
	#if Input.is_action_pressed("move_left"):
	#	move_vec.x -= 1
	#if Input.is_action_pressed("move_right"):
	#	move_vec.x += 1
		
	#controller_move_vec = Vector2()
	move_vec.x = Input.get_axis("move_left", "move_right")
	move_vec.y = Input.get_axis("move_up", "move_down")
		
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

	if healthbar != null:
		healthbar.value = lerp(healthbar.value, hp, lerpSpd * delta)
	if staminabar != null:
		staminabar.value = lerp(staminabar.value, stamina, lerpSpd * delta)
	
	if staminabar != null and staminabar.value > boostStaminaVal:
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
		
	#Fire status effect
	#############
	#######
	##
	######
	#############
	if inFire and curFire <= fireThreshold:
		curFire += delta
		
		FireDamage()
		
	if curFire > 0 and !inFire:
		curFire -= delta

func Boost():
	#move_and_collide(move_vec * boostSpd)
	#boosting = true
	stamina -= boostStaminaVal
	boost_vec = move_vec
	boostTimer = timeBetweenBoosts + timeWeBoost
	curBoostTimer = timeWeBoost

func Damage(amt, pos = global_position):
	if iframes <= 0:
		hp -= amt
		iframes = iframesTime
		
		play_anim("hit")
		SpawnPart(pos)
	
	if hp <= 0:
		Kill()

#Fire damage should start to overheat our weapons too
################
############
######
##
#####
###########
###############
func FireDamage():
	#if iframes <= 0:
	hp -= fireDmg
		#iframes = iframesTime
		
		#play_anim("hit")
	
	if hp <= 0:
		Kill()
		

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)

func SpawnPart(pos):
	#Spawn particles
	var s = sparkParts.instance()
	s.emitting = true
	get_tree().current_scene.add_child(s)
	s.global_position = pos
	#s.get_node("Timer").wait_time = stunTime

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
