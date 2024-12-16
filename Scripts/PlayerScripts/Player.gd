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
export var shitSpd = 125
export var forwardSpd = 300
export var backwardSpd = 300
export var sideSpd = 300

#UI
export(float) var lerpSpd = 15.0
onready var healthbar = get_node("/root/World/UI/Health")
onready var staminabar = get_node("/root/World/UI/Stamina2/Stamina")
onready var dashBar = get_node("/root/World/UI/DashBich")

export var iframesTime : float = 0.3
var iframes : float = 0

var move_vec : Vector2
var controller_aim : Vector2
var boost_vec : Vector2

#Spark hit particles
export(PackedScene) var sparkParts
export(PackedScene) var honeyParts

#Animation
onready var anim = $AnimationPlayer

#Status effects
#Fire
var inFire : bool = false
export(float) var fireDmg = 1.75
export(float) var overheatAmt = 1
export(float) var fireThreshold
var curFire : float = 0.0
#Honey
var honeyed : float = 0.0
export(float) var honeyRed = 1.0
export(float) var honeyShotRed = 10.0
export(float) var maxHoney = 100.0
onready var honeySpriteL = $Node2D/MechBody/HoneyL
onready var honeySpriteR = $Node2D/MechBody/HoneyR
onready var honeyVision = $Node2D/HoneyVision

#Charge dash variables
onready var tim = $Node2D/MechBody/Timer
export var boostSpd = 500
var chargeTime : float = 0.0
var boostTimer : float = 0.0
export(float) var maxCharge = 3.0
export(float) var timeBetweenDashes = 3.0
export(float) var curInBetweenDashTime = 3.0
var boostAddition : float = 0.0
export(float) var timeToCharge = 33.34
var boosting : bool = false
var curBoostTimer : float = 0

var gameoverRoot

var shitCount : int = 0
export(float) var shitSpdRed = 50.0
export(float) var shitDmg = 5.0
export(float) var shitTimer = 3.0
export(float) var minShit = 10.0
export(float) var timeBetweenShitDmg = 10.0
var shitDmgTimer = 0.0
var curShitting : float = 0.0

var webbed : bool = false
export(int) var webMove = 4
var curWebbing : int = 0

export(String) var soundName = "MetalHit"
var snd

func _ready():
	honeySpriteL.hide()
	honeySpriteR.hide()
	snd = load("res://Audio/SFX/" + soundName + ".wav")
	gameoverRoot = get_node("/root/World/GameOverRoot")
	
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
		
	#if curBoostTimer <= 0:
	#	boosting = false
	
	curLerpSpd = spdLerpSpd
		
	if curBoostTimer <= 0:
		boost_vec = Vector2(0, 0)
	
	#curLerpSpd = boostLerpSpd if boosting == true else spdLerpSpd
	boosting = true if curBoostTimer > 0 else false
	
	if (move_vec.x != 0 or move_vec.y != 0):
		if Input.is_action_pressed("sprint") and boostTimer <= 0 and stamina >= boostStaminaVal:
			if chargeTime < maxCharge:
				chargeTime += delta * timeToCharge
			
				boostAddition = -backwardSpd

		if Input.is_action_just_released("sprint") and boostTimer <= 0 and stamina >= boostStaminaVal and chargeTime > 0:
			Boost(chargeTime)
	
	dashBar.value = lerp(dashBar.value, chargeTime, lerpSpd * delta)
	
	
	if shitCount > 0:
		spdToLerpTo = shitSpd + boostAddition
		spdToLerpTo = clamp(spdToLerpTo, 0, 10000)
	else:
		spdToLerpTo = regSpd + boostAddition
		spdToLerpTo = clamp(spdToLerpTo, 0, 10000)
	#spdToLerpTo = backwardSpd
	
	if chargeTime <= 0:
		dashBar.hide()
	else:
		dashBar.show()
	
	#Might need to be indented 1 more
	#if boosting:
	#	spdToLerpTo = forwardSpd
	
	if !boosting:
		boostAddition = 0
	
		#if Input.is_action_pressed("sprint") and stamina > 0 and !boosting:
		#	stamina -= delta * staminaDecAmt
		#	spdToLerpTo = forwardSpd
		if Input.is_action_pressed("sprint") == false and !boosting:
			#spdToLerpTo = regSpd
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
	if boosting == false and !webbed:
		move_and_collide(move_vec * curSpd * delta)
	if boost_vec != Vector2(0, 0) and !webbed:
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
		
	#Honey status effect
	if honeyed > 0:
		honeyed -= honeyRed * delta
		
	if honeyed <= 0:
		honeySpriteL.hide()
		honeySpriteR.hide()
		
	if shitCount > 0 and curShitting < minShit:
		curShitting += delta
		
	if curShitting >= minShit and shitDmgTimer <= 0:
		ShitDamage(shitDmg)
		shitDmgTimer = timeBetweenShitDmg
		$ShitTimer.start()
		
	if shitDmgTimer > 0:
		shitDmgTimer -= delta
		
	if shitDmgTimer <= 0 and curShitting >= minShit:
		ShitDamage(shitDmg)
		if curShitting >= minShit:
			shitDmgTimer = timeBetweenShitDmg
	
	if webbed:
		#if move_vec.x != 0 or move_vec.y != 0:
		#	curWebbing -= 1
			
		if Input.is_action_just_pressed("move_left"):
			position.x -= 0.1
			curWebbing -= 1
		if Input.is_action_just_pressed("move_right"):
			position.x += 0.1
			curWebbing -= 1
		if Input.is_action_just_pressed("move_up"):
			position.y -= 0.1
			curWebbing -= 1
		if Input.is_action_just_pressed("move_down"):
			position.y += 0.1
			curWebbing -= 1
			
	if curWebbing <= 0:
		webbed = false
		$WebSprite.hide()

func Boost(charge = 0.1):
	#move_and_collide(move_vec * boostSpd)
	#boosting = true
	stamina -= boostStaminaVal
	boost_vec = move_vec
	boostAddition = charge * forwardSpd
	boostTimer = timeBetweenDashes + tim.wait_time
	chargeTime = 0
	tim.start()

func Damage(amt, pos = global_position):
	if iframes <= 0:
		play_sound(snd, true)
		hp -= amt
		iframes = iframesTime
		
		play_anim("hit")
		SpawnPart(pos)
	
	if hp <= 0:
		Kill()

func ShitDamage(amt, pos = global_position):
	play_sound(snd, true)
	hp -= amt
	iframes = iframesTime
		
	play_anim("hit")
	SpawnPart(pos)
	
	if hp <= 0:
		Kill()
		
func GetHoneyed(amt = 25):
	var newH = honeyed + amt
	if newH > maxHoney:
		honeyed = maxHoney
	else:
		honeyed = newH
		
	if honeySpriteL.is_visible_in_tree() or honeySpriteR.is_visible_in_tree():
		return
	var rand = rand_range(0, 1)
	if rand > 0.5:
		honeySpriteL.show()
	else:
		honeySpriteR.show()
		
func GetShit():
	shitCount += 1
		
func RedShit():
	if shitCount > 0:
		shitCount -= 1
		
func Webbed():
	webbed = true
	curWebbing = webMove
	$WebSprite.show()

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
	$Node2D/MechBody.overheatL += overheatAmt
	$Node2D/MechBody.overheatR += overheatAmt
	
		#iframes = iframesTime
		
		#play_anim("hit")
	
	if hp <= 0:
		Kill()
	
func HoneyShot(pos, red = honeyShotRed):
	honeyed -= red
	SpawnHoneyPart(pos)

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)
	
func SpawnHoneyPart(pos):
	var s = honeyParts.instance()
	s.emitting = true
	get_tree().current_scene.add_child(s)
	s.global_position = pos
	

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
	
	#Play death animation
	#Load gameover menu after x seconds
	#Button to retry level/load checkpoint
	gameoverRoot.show()
	var con = get_node("/root/World/GameOverRoot/CenterContainer/VBoxContainer/VBoxContainer/ContinueButton")
	con.grab_focus()
	get_tree().paused = true
	
	pass


func _on_Timer_timeout():
	boosting = false
	
export(float) var pitchLow = 0.8
export(float) var pitchHigh = 1.3
func play_sound(s = snd, pitched = false):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		$PlayerSounds.pitch_scale = rand_range(pitchLow, pitchHigh)
	$PlayerSounds.stream = s
	$PlayerSounds.play()


func _on_ShitTimer_timeout():
	curShitting = 0
