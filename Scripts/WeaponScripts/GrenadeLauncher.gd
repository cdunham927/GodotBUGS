extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	var b = bullet.instance()
	b.global_position = $Muzzle.global_position
	b.rotation = $Muzzle.global_rotation
	get_tree().current_scene.add_child(b)
	ShowFlash()
	curShotTime = timeBetweenShots
	if leftWeapon:
		mech.overheatL += incAmt
	else:
		mech.overheatR += incAmt
	#gatlingOverheat += 1
	
	get_tree().current_scene.get_node("Camera2D").add_trauma(0.325)
	
	if overheatUI.value >= overheatUI.max_value:
		recover = recoverTime

func ShowFlash():
	#flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
