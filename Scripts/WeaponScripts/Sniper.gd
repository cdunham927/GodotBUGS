extends "res://Scripts/PlayerScripts/WeaponController.gd"

func _ready():
	playerParent = get_parent().get_parent().get_parent().get_parent()
	snd = load("res://Audio/SFX/" + soundName + ".wav")
	snd3 = load("res://Audio/SFX/" + squirt + ".wav")
	if self.is_visible_in_tree():
		Activate()

func Shoot():
	if leftWeapon:
		play_sound(snd, true, soundL, soundL2)
	else:
		play_sound(snd, true, soundR, soundR2)
		
	var b = bullet.instantiate()
	get_node("/root/World").add_child(b)
	b.start(Callable($Muzzle.global_position, $Muzzle.global_rotation).bind(accuracy))
	ShowFlash()
	#b.Setup()
	#world.add_child(b)
	#b.transform = $Muzzle.global_transform
	#b.RandomizeSpeed()
	b.show()
	curShotTime = timeBetweenShots
	if leftWeapon:
		mech.overheatL += incAmt
	else:
		mech.overheatR += incAmt
	#gatlingOverheat += 1
	
	get_node("/root/World").get_node("Camera2D").add_trauma(0.225)

func ShowFlash():
	#flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
