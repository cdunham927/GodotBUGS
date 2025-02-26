extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	if leftWeapon:
		play_sound(snd, true, soundL)
	else:
		play_sound(snd, true, soundR)
	
	var b = bullet.instance()
	#get_tree().current_scene.add_child(b)
	get_node("/root/World").add_child(b)
	b.start($Muzzle.global_position, $Muzzle.global_rotation, accuracy)
	ShowFlash()
	#b.Setup()
	#b.transform = $Muzzle.global_transform
	b.RandomizeSpeed()
	#b.show()
	curShotTime = timeBetweenShots
	if leftWeapon:
		mech.overheatL += incAmt
	else:
		mech.overheatR += incAmt
	#gatlingOverheat += 1
	
	get_node("/root/World/Camera2D").add_trauma(0.0375)
