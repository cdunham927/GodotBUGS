extends "res://Scripts/PlayerScripts/WeaponController.gd"

onready var muzzles = $MuzzleParent

func Shoot():
	for i in muzzles.get_children():
		var b = bulletPool.GetPoolObject()
		#b.Setup()
		world.add_child(b)
		b.transform = i.global_transform
		b.RandomizeSpeed()
		b.global_rotation = i.global_rotation
		b.show()
	
	ShowFlash()
	curShotTime = timeBetweenShots
	overheat += incAmt
		#gatlingOverheat += 1
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime
