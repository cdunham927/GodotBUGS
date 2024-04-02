extends "res://Scripts/PlayerScripts/WeaponController.gd"

onready var muzzles = $MuzzleParent
var hasSpawned = false
export var pellet: PackedScene

func Shoot():
	for i in muzzles.get_children():
		var b = bullet.instance()
		get_tree().current_scene.add_child(b)
		b.start(muzzles.global_position, muzzles.global_rotation, accuracy)
		#b.transform = i.global_transform
		#b.RandomizeSpeed()
		#b.global_rotation = i.global_rotation
		b.show()
		
	get_tree().current_scene.get_node("Camera2D").add_trauma(0.2)
	
	#Spawn a pellet
	var p = pellet.instance()
	p.lPel = leftWeapon
	get_tree().current_scene.add_child(p)
	p.global_position = muzzles.global_position
	
	ShowFlash()
	curShotTime = timeBetweenShots
	overheat += incAmt
	#gatlingOverheat += 1
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime

func ShowFlash():
	#flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05
