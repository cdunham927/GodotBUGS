extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	var b = bullet.instance()
	b.global_position = $Muzzle.global_position
	b.rotation = $Muzzle.global_rotation
	get_tree().current_scene.add_child(b)
	ShowFlash()
	curShotTime = timeBetweenShots
	overheat += incAmt
	#gatlingOverheat += 1
	
	get_tree().current_scene.get_node("Camera2D").add_trauma(0.325)
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime

func ShowFlash():
	#flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
