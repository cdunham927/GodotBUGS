extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	var b = bullet.instance()
	get_node("/root/World").add_child(b)
	b.start($Muzzle.global_position, $Muzzle.global_rotation, accuracy)
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
