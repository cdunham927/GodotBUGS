extends Sprite

export var offsetZ : float = 85
#All our weapons are parent gameobjects that get hidden and shown when in and out of use
onready var weaponChildrenLeft = $WeaponsLeft.get_children()
onready var weaponChildrenRight = $WeaponsRight.get_children()

export(float) var rotationConstraint

export var unlockedLeft = [ true, true, true ]
export var unlockedRight = [ true, true, true ]
var curLeft := 0
var curRight := 0
var lastWeaponLeft := 0
var lastWeaponRight := 0

export var rotSpd : float = 15
var controller : bool = false

func _ready():
	curLeft = 0
	curRight = 0
	lastWeaponLeft = curLeft
	lastWeaponRight = curRight

func SwitchWeaponLeft():
	weaponChildrenLeft[lastWeaponLeft].hide()
	weaponChildrenLeft[curLeft].show()
	weaponChildrenLeft[curLeft].Activate()
	#if curLeft == 0:
	#	weaponChildren[weaponSize / 2 - 1].hide()
	#	weaponChildren[0].show()
	#	weaponChildren[0].Activate()
	#else:
	#	weaponChildren[curLeft - 1].hide()
	#	weaponChildren[curLeft].show()
	#	weaponChildren[curLeft].Activate()

func SwitchWeaponRight():
	weaponChildrenRight[lastWeaponRight].hide()
	weaponChildrenRight[curRight].show()
	weaponChildrenRight[curRight].Activate()
	#if curRight == weaponSize / 2:
	#	weaponChildren[weaponSize - 1].hide()
	#	weaponChildren[weaponSize / 2].show()
	#	weaponChildren[weaponSize / 2].Activate()
	#else:
	#	weaponChildren[curRight - 1].hide()
	#	weaponChildren[curRight].show()
	#	weaponChildren[curRight].Activate()

func _process(delta):
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
