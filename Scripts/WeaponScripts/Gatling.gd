extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	var b = bulletPool.GetPoolObject()
	ShowFlash()
	#b.Setup()
	world.add_child(b)
	b.transform = $Muzzle.global_transform
	b.RandomizeSpeed()
	b.show()
	curShotTime = timeBetweenShots
	overheat += incAmt
	#gatlingOverheat += 1
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime
