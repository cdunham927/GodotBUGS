extends "res://Scripts/PlayerScripts/WeaponController.gd"

@onready var muzzles = $MuzzleParent
var hasSpawned = false
@export var pellet: PackedScene
@export var soundName2 : String = "SingleReload"
var snd2

func _ready():
	playerParent = get_parent().get_parent().get_parent().get_parent()
	snd = load("res://Audio/SFX/" + soundName + ".wav")
	snd2 = load("res://Audio/SFX/" + soundName2 + ".mp3")
	snd3 = load("res://Audio/SFX/" + squirt + ".wav")
	if self.is_visible_in_tree():
		Activate()

func Shoot():
	if leftWeapon:
		play_sound(snd, true, soundL, soundL2)
		$SGTimerL.start()
	else:
		play_sound(snd, true, soundR, soundR2)
		$SGTimerR.start()
		
	for i in muzzles.get_children():
		var b = bullet.instantiate()
		get_node("/root/World").add_child(b)
		b.start(Callable(muzzles.global_position, muzzles.global_rotation).bind(accuracy))
		#b.transform = i.global_transform
		#b.RandomizeSpeed()
		#b.global_rotation = i.global_rotation
		b.show()
		
	get_node("/root/World/Camera2D").add_trauma(0.2)
	
	#Spawn a pellet
	var p = pellet.instantiate()
	p.lPel = leftWeapon
	get_node("/root/World").add_child(p)
	p.global_position = muzzles.global_position
	
	ShowFlash()
	curShotTime = timeBetweenShots
	
	if leftWeapon:
		mech.overheatL += incAmt
	else:
		mech.overheatR += incAmt
	#gatlingOverheat += 1
	
	#Old overheat
	#if overheat >= overheatTotal + incAmt:
	#	recover = recoverTime

func ShowFlash():
	#flash.rotation_degrees = rand_range(0, 360)
	flash.show()
	flashTimer = 0.05

func _on_SGTimerL_timeout():
	play_sound(snd2, false, soundL, soundL2)


func _on_SGTimerR_timeout():
	play_sound(snd2, false, soundR, soundR2)
