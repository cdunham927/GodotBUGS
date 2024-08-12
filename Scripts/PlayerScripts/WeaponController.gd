extends Node2D

#enum weapons { gatlinggun, flamethrower, teslacannon, revolver, canonball, shotgun }
#export var state = weapons[0]
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

func _ready():
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
			Shoot()
		#Left weapon stop shooting
		if leftWeapon and Input.is_action_just_released("attack"):
			mech.tilNotShootingL = tilNotShootingMin
		#Right weapon start shooting
		if !leftWeapon and Input.is_action_pressed("attacktwo") and curShotTime <= 0 and mech.recoverR <= 0:
			#shooting = true
			mech.tilNotShootingR = tilNotShootingMin
			Shoot()
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

func ShowFlash():
	flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
	
