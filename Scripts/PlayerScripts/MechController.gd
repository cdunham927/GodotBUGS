extends Sprite2D

@export var offsetZ : float = 85
#All our weapons are parent gameobjects that get hidden and shown when in and out of use
@onready var weaponChildrenLeft = $WeaponsLeft.get_children()
@onready var weaponChildrenRight = $WeaponsRight.get_children()

@export var rotationConstraint: float

@export var unlockedLeft = [ true, true, true ]
@export var unlockedRight = [ true, true, true ]
var curLeft := 0
var curRight := 0
var lastWeaponLeft := 0
var lastWeaponRight := 0

@export var rotSpd : float = 15
var controller : bool = false

var overheatL : float = 0.0
var overheatR : float = 0.0

@export var recoveryModifier: float = 3.0
@export var recoveryModifierIncrease: float = 2
@export var recovModLerp: float = 0.5
@export var curRecovMod: float = 0.25
@export var curRecovModR: float = 0.25
@export var recoverTime: float
var recoverL : float = 0.0
var recoverR : float = 0.0

@onready var overheatUI = get_node("/root/World/UI/EquippedWeaponLeftActualBichPls")
@onready var overheatUI2 = get_node("/root/World/UI/EquippedWeaponRightActualBichPls")
@onready var weaponLeftLabel = get_node("/root/World/UI/EquippedWeaponLeftActualBichPls/EquippedLabel")
@onready var weaponRightLabel = get_node("/root/World/UI/EquippedWeaponRightActualBichPls/EquippedLabel")

@export var goodColor: Color
@export var overheatColor: Color

var tilNotShootingL : float = 0.1
var tilNotShootingR : float = 0.1

@onready var src = $MechSounds
@export var overheatSnd: String = "SteamOverheat"
var snd
var playedOverheat : bool = false

func _ready():
	snd = load("res://Audio/SFX/" + overheatSnd + ".wav")
	curLeft = 0
	curRight = 0
	lastWeaponLeft = curLeft
	lastWeaponRight = curRight
	
	#Name UI weapon shit bich
	weaponLeftLabel.text = weaponChildrenLeft[curLeft].weaponName
	weaponRightLabel.text = weaponChildrenRight[curRight].weaponName

func SwitchWeaponLeft():
	weaponChildrenLeft[lastWeaponLeft].hide()
	weaponChildrenLeft[curLeft].show()
	weaponChildrenLeft[curLeft].Activate()
	
	var text = weaponChildrenLeft[curLeft].weaponName
	weaponLeftLabel.text = text

func SwitchWeaponRight():
	weaponChildrenRight[lastWeaponRight].hide()
	weaponChildrenRight[curRight].show()
	weaponChildrenRight[curRight].Activate()
	
	var text = weaponChildrenRight[curRight].weaponName
	weaponRightLabel.text = text

func _process(delta):
	if recoverL > 0:
		overheatUI.tint_progress = overheatColor
		recoverL -= delta
	else:
		overheatUI.tint_progress = goodColor
	if recoverR > 0:
		overheatUI2.tint_progress = overheatColor
		recoverR -= delta
	else:
		overheatUI2.tint_progress = goodColor
		
	if overheatL >= overheatUI.max_value and recoverL <= 0:
		recoverL = recoverTime
		curRecovMod = 0.0
		play_sound(snd)
	if overheatR >= overheatUI2.max_value and recoverR <= 0:
		recoverR = recoverTime
		curRecovModR = 0.0
		play_sound(snd)

	if tilNotShootingL <= 0 and overheatL > 0:
		overheatL -= delta * (recoveryModifier + curRecovMod)
	if tilNotShootingR <= 0 and overheatR > 0:
		overheatR -= delta * (recoveryModifier + curRecovModR)
	
	if tilNotShootingL > 0:
		tilNotShootingL -= delta
	if tilNotShootingR > 0:
		tilNotShootingR -= delta

	curRecovMod = lerp(curRecovMod, recoveryModifierIncrease, recovModLerp * delta)
	curRecovModR = lerp(curRecovMod, recoveryModifierIncrease, recovModLerp * delta)
	
	#Controller aiming
	var aim_dir = Vector2(Input.get_axis("aim_left", "aim_right"), Input.get_axis("aim_up", "aim_down")) 
	if aim_dir != Vector2.ZERO:
		controller = true
		
	#if Input.is_key_pressed(key):
	#	controller = false
	
	
	if controller and aim_dir != Vector2.ZERO:
		rotation = lerp_angle(rotation, aim_dir.angle() + offsetZ, 0.5)
	
	if !controller:
		#Mouse aiming
		var look_vec = get_global_mouse_position() - global_position
		global_rotation = lerp_angle(global_rotation, atan2(look_vec.y, look_vec.x) + offsetZ, rotSpd)
	
	if Input.is_action_just_pressed("switch_left"):
		if curLeft + 1 < unlockedLeft.size():
			if unlockedLeft[curLeft + 1] == true:
				lastWeaponLeft = curLeft
				curLeft += 1
				SwitchWeaponLeft()
			else:
				var testSlot = curLeft
				if testSlot < unlockedLeft.size():
					while testSlot < unlockedLeft.size():
						testSlot += 1
						if unlockedLeft[testSlot] == true:
							lastWeaponLeft = curLeft
							curLeft = testSlot
							SwitchWeaponLeft()
							break
		else:
			lastWeaponLeft = weaponChildrenLeft.size() - 1
			curLeft = 0
			SwitchWeaponLeft()
	
	if Input.is_action_just_pressed("switch_right"):
		if curRight + 1 < unlockedRight.size():
			if unlockedRight[curRight + 1] == true:
				lastWeaponRight = curRight
				curRight += 1
				SwitchWeaponRight()
			else:
				var testSlot = curRight
				if testSlot < unlockedRight.size():
					while testSlot < unlockedRight.size():
						testSlot += 1
						if unlockedRight[testSlot] == true:
							lastWeaponRight = curRight
							curRight = testSlot
							SwitchWeaponRight()
							break
		else:
			lastWeaponRight = weaponChildrenRight.size() - 1
			curRight = 0
			SwitchWeaponRight()
		
	#mechArm1.rotation_degrees = clamp(atan2(look_vec.y, look_vec.x), global_rotation - rotationConstraint, global_rotation + rotationConstraint)
	#mechArm2.rotation_degrees = clamp(atan2(look_vec.y, look_vec.x), global_rotation - rotationConstraint, global_rotation + rotationConstraint)

@export var pitchLow: float = 0.8
@export var pitchHigh: float = 1.3
func play_sound(s = snd, pitched = false):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		src.pitch_scale = randf_range(pitchLow, pitchHigh)
	src.stream = s
	src.play()
