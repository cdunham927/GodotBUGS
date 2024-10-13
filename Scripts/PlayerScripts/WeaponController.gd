extends Node2D

#enum weapons { gatlinggun, flamethrower, teslacannon, revolver, canonball, shotgun }
#export var state = weapons[0]
var playerParent
export(String) var weaponName = "" 
export(PackedScene) var bullet

export(float) var timeBetweenShots = 0.2
var curShotTime : float = 0
onready var flash = $Flash
var flashTimer : float = 0
var shooting : bool = false

onready var mech = get_parent().get_parent()
export(bool) var leftWeapon = false
onready var overheatUI = get_node("/root/World/UI/EquippedWeaponLeftActualBichPls")
onready var overheatUI2 = get_node("/root/World/UI/EquippedWeaponRightActualBichPls")
#export(float) var overheatTotal = 25.0
export(float) var incAmt = 0.5

export(float) var lerpSpd = 15.0

export(float) var tilNotShootingMin = 0.25

export(float) var accuracy

var active := false

onready var soundL = get_node("/root/World/Player/Node2D/MechBody/WeaponsLSounds")
onready var soundR = get_node("/root/World/Player/Node2D/MechBody/WeaponsRSounds")
export(String) var soundName = "minigun2"
#export(String) var overheatSnd = "SteamOverheat"
export(String) var squirt = "Squirt"
var snd
#var snd2
var snd3
var playedOverheat : bool = false

#Honey sprites
onready var honeyL = get_node("/root/World/Player/Node2D/MechBody/HoneyL")
onready var honeyR = get_node("/root/World/Player/Node2D/MechBody/HoneyR")
export(float) var honeyRed = 20.0

func _ready():
	playerParent = get_parent().get_parent().get_parent().get_parent()
	snd = load("res://Audio/SFX/" + soundName + ".wav")
	snd3 = load("res://Audio/SFX/" + squirt + ".wav")
	if self.is_visible_in_tree():
		Activate()

func Activate():
	#if leftWeapon and overheatUI != null:
	#	overheatUI.max_value = overheatTotal
	#else:
	#	if overheatUI2 != null:
	#		overheatUI2.max_value = overheatTotal
	pass

func _process(delta):
	if overheatUI == null:
		overheatUI = get_node("/root/World2/UI/Overheat")
	if overheatUI2 == null:
		overheatUI2 = get_node("/root/World2/UI/Overheat2")
	#var look_vec = get_global_mouse_position() - global_position
	#rotation_degrees = clamp(atan2(look_vec.y, look_vec.x), -rotationConstraint, rotationConstraint)
	#rotation_degrees = atan2(look_vec.y, look_vec.x)
	active = self.is_visible_in_tree()

	if active:
		#Left weapon start shooting
		if leftWeapon and Input.is_action_pressed("attack") and curShotTime <= 0 and mech.recoverL <= 0:
			#shooting = true
			mech.tilNotShootingL = tilNotShootingMin
			if !honeyL.is_visible_in_tree():
				Shoot()
			else:
				ShootHoney()
		#Left weapon stop shooting
		if leftWeapon and Input.is_action_just_released("attack"):
			mech.tilNotShootingL = tilNotShootingMin
		#Right weapon start shooting
		if !leftWeapon and Input.is_action_pressed("attacktwo") and curShotTime <= 0 and mech.recoverR <= 0:
			#shooting = true
			mech.tilNotShootingR = tilNotShootingMin
			if !honeyR.is_visible_in_tree():
				Shoot()
			else:
				ShootHoney()
		#Right weapon stop shooting
		if leftWeapon == false and Input.is_action_just_released("attacktwo"):
			mech.tilNotShootingR = tilNotShootingMin

		#Hide UI when overheat is less than 0
		##############
		######
		###
		##
		###
		######
		##############
		#if overheat <= 0 and overheatUI != null and overheatUI2 != null:
		#	if leftWeapon:
		#		overheatUI.hide()
		#	else:
		#		overheatUI2.hide()
		#else:
		#	if overheatUI != null and overheatUI2 != null:
		#		if leftWeapon:
		#			overheatUI.show()
		#		else:
		#			overheatUI2.show()
		
		if curShotTime > 0:
			curShotTime -= delta
		if flashTimer > 0:
			flashTimer -= delta
		else:
			flash.hide()
	
		if leftWeapon and overheatUI != null:
			 overheatUI.value = lerp(overheatUI.value, mech.overheatL, lerpSpd * delta)
		else:
			if overheatUI2 != null:
				overheatUI2.value = lerp(overheatUI2.value, mech.overheatR, lerpSpd * delta)

func Shoot():
	pass
	
func ShootHoney():
	if leftWeapon:
		play_sound(snd3, true, soundL)
	else:
		play_sound(snd3, true, soundR)
	curShotTime = timeBetweenShots
	playerParent.HoneyShot(flash.global_position, honeyRed)

func ShowFlash():
	flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
	
export(float) var pitchLow = 0.8
export(float) var pitchHigh = 1.3
func play_sound(s = snd, pitched = false, player = soundL):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		player.pitch_scale = rand_range(pitchLow, pitchHigh)
	player.stream = s
	player.play()
