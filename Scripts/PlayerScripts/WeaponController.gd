extends Node2D

#enum weapons { gatlinggun, flamethrower, teslacannon, revolver, canonball, shotgun }
#export var state = weapons[0]

export var poolName = ""
onready var bulletPool = get_node("/root/World/" + poolName)
onready var world = get_node("/root/World")
export(float) var timeBetweenShots = 0.2
var curShotTime : float = 0
onready var flash = $Flash
var flashTimer : float = 0
var shooting : bool = false
var tilNotShooting : float = 0.1

export(bool) var leftWeapon = false
onready var overheatUI = get_node("/root/World/UI/Overheat")
onready var overheatUI2 = get_node("/root/World/UI/Overheat2")
export(float) var overheatTotal = 25
export(float) var incAmt = 0.5
export(float) var recoveryModifier = 3
var overheat : float = 0
export(float) var recoverTime
var recover : float = 0

export(float) var lerpSpd = 15

export(Color) var goodColor
export(Color) var overheatColor

export(float) var tilNotShootingMin = 0.25

export(float) var accuracy

var active := false

func _ready():
	if self.is_visible_in_tree():
		Activate()

func Activate():
	if leftWeapon:
		overheatUI.max_value = overheatTotal
	else:
		overheatUI2.max_value = overheatTotal

func _process(delta):
	#var look_vec = get_global_mouse_position() - global_position
	#rotation_degrees = clamp(atan2(look_vec.y, look_vec.x), -rotationConstraint, rotationConstraint)
	#rotation_degrees = atan2(look_vec.y, look_vec.x)
	active = self.is_visible_in_tree()

	if active:
		#Left weapon start shooting
		if leftWeapon and Input.is_action_pressed("attack") and curShotTime <= 0 and recover <= 0:
			#shooting = true
			tilNotShooting = tilNotShootingMin
			Shoot()
		#Left weapon stop shooting
		if leftWeapon and Input.is_action_just_released("attack"):
			tilNotShooting = tilNotShootingMin
		#Right weapon start shooting
		if leftWeapon == false and Input.is_action_pressed("attacktwo") and curShotTime <= 0 and recover <= 0:
			#shooting = true
			tilNotShooting = tilNotShootingMin
			Shoot()
		#Right weapon stop shooting
		if leftWeapon == false and Input.is_action_just_released("attacktwo"):
			tilNotShooting = tilNotShootingMin
		
	#if tilNotShooting <= 0:
	#	shooting = false
	
		if overheat <= 0:
			if leftWeapon:
				overheatUI.hide()
			else:
				overheatUI2.hide()
		else:
			if leftWeapon:
				overheatUI.show()
			else:
				overheatUI2.show()

		if recover <= 0 and tilNotShooting <= 0 and overheat > 0:
			overheat -= delta * recoveryModifier
	#Decrement nums
		if recover > 0:
			if leftWeapon:
				overheatUI.tint_progress = overheatColor
			else:
				overheatUI2.tint_progress = overheatColor
			recover -= delta
		else:
			if leftWeapon:
				overheatUI.tint_progress = goodColor
			else:
				overheatUI2.tint_progress = goodColor
		if tilNotShooting > 0:
			tilNotShooting -= delta
		if curShotTime > 0:
			curShotTime -= delta
		if flashTimer > 0:
			flashTimer -= delta
		else:
			flash.hide()
	
		if leftWeapon:
			 overheatUI.value = lerp(overheatUI.value, overheat, lerpSpd * delta)
		else:
			 overheatUI2.value = lerp(overheatUI2.value, overheat, lerpSpd * delta)

func Shoot():
	pass

func ShowFlash():
	flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
	
