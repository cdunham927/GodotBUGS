extends Node2D

#enum weapons { gatlinggun, flamethrower, teslacannon, revolver, canonball, shotgun }
#export var state = weapons[0]
var playerParent
@export var weaponName: String = "" 
@export var bullet: PackedScene

@export var timeBetweenShots: float = 0.2
var curShotTime : float = 0
@onready var flash = $Flash
var flashTimer : float = 0
var shooting : bool = false

@onready var mech = get_parent().get_parent()
@export var leftWeapon: bool = false
@onready var overheatUI = get_node("/root/World/UI/EquippedWeaponLeftActualBichPls")
@onready var overheatUI2 = get_node("/root/World/UI/EquippedWeaponRightActualBichPls")
#export(float) var overheatTotal = 25.0
@export var incAmt: float = 0.5

@export var lerpSpd: float = 15.0

@export var tilNotShootingMin: float = 0.25

@export var accuracy: float

var active := false

@onready var soundL = get_node("/root/World/Player/Node2D/MechBody/WeaponsLSounds")
@onready var soundL2 = get_node("/root/World/Player/Node2D/MechBody/WeaponsLSounds2")
@onready var soundR = get_node("/root/World/Player/Node2D/MechBody/WeaponsRSounds")
@onready var soundR2 = get_node("/root/World/Player/Node2D/MechBody/WeaponsRSounds2")
@export var soundName: String = "minigun"
#export(String) var overheatSnd = "SteamOverheat"
@export var squirt: String = "Squirt"
var snd
#var snd2
var snd3
var playedOverheat : bool = false

#Honey sprites
@onready var honeyL = get_node("/root/World/Player/Node2D/MechBody/HoneyL")
@onready var honeyR = get_node("/root/World/Player/Node2D/MechBody/HoneyR")
@export var honeyRed: float = 20.0

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
		play_sound(snd3, true, soundL, soundL2)
	else:
		play_sound(snd3, true, soundR, soundR2)
	curShotTime = timeBetweenShots
	playerParent.HoneyShot(flash.global_position, honeyRed)

func ShowFlash():
	flash.rotation_degrees = randf_range(0, 360)
	flash.show()
	flashTimer = 0.05
	
@export var pitchLow: float = 0.8
@export var pitchHigh: float = 1.3
func play_sound(s = snd, pitched = false, player = soundL, player2 = soundL2):
	#if !canPlay:
	#	canPlay = true
	#	return
	if !player.is_playing():
		if pitched:
			player.pitch_scale = randf_range(pitchLow, pitchHigh)
		else:
			player.pitch_scale = 1.0
		player.stream = s
		player.play()
	else:
		if pitched:
			player2.pitch_scale = randf_range(pitchLow, pitchHigh)
		player2.stream = s
		player2.play()
