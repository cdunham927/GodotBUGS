extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	var b = bulletPool.GetPoolObject()
	b.start($Muzzle.global_position, $Muzzle.global_rotation, accuracy)
	ShowFlash()
	#b.Setup()
	#b.transform = $Muzzle.global_transform
	b.RandomizeSpeed()
	b.show()
	curShotTime = timeBetweenShots
	overheat += incAmt
	#gatlingOverheat += 1
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime
