extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	#$Area2D.monitoring = true
	#$FlamethrowerFire2.emitting = true
	
	#$RigidFlamethrower.emit = true
	
	#ShowFlash()
	#curShotTime = timeBetweenShots
	if leftWeapon:
		mech.overheatL += incAmt
	else:
		mech.overheatR += incAmt
	
	get_node("/root/World/Camera2D").add_trauma(0.001)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("Damage"):
			body.inFire = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("enemies"):
		if body.has_method("Damage"):
			body.inFire = false

func _process(delta):
	if overheatUI == null:
		overheatUI = get_node("/root/World2/UI/Overheat")
	if overheatUI2 == null:
		overheatUI2 = get_node("/root/World2/UI/Overheat2")
	#var look_vec = get_global_mouse_position() - global_position
	#rotation_degrees = clamp(atan2(look_vec.y, look_vec.x), -rotationConstraint, rotationConstraint)
	#rotation_degrees = atan2(look_vec.y, look_vec.x)
	active = self.is_visible_in_tree()

	if active:
		#Left weapon start shooting
		if leftWeapon and Input.is_action_pressed("attack") and curShotTime <= 0 and mech.recoverL <= 0:
			#shooting = true
			mech.tilNotShootingL = tilNotShootingMin
			if !honeyL.is_visible_in_tree():
				Shoot()
			else:
				ShootHoney()
		#Left weapon stop shooting
		if leftWeapon and Input.is_action_just_released("attack"):
			#$Area2D.monitoring = false
			#$FlamethrowerFire2.emitting = false
			
	
			#$RigidFlamethrower.emit = false
			
			mech.tilNotShootingL = tilNotShootingMin
		#Right weapon start shooting
		if leftWeapon == false and Input.is_action_pressed("attacktwo") and curShotTime <= 0 and mech.recoverR <= 0:
			#shooting = true
			mech.tilNotShootingR = tilNotShootingMin
			if !honeyR.is_visible_in_tree():
				Shoot()
			else:
				ShootHoney()
		#Right weapon stop shooting
		if leftWeapon == false and Input.is_action_just_released("attacktwo"):
			$Area2D.monitoring = false
			$FlamethrowerFire2.emitting = false
			mech.tilNotShootingR = tilNotShootingMin
		
		if curShotTime > 0:
			curShotTime -= delta
		if flashTimer > 0:
			flashTimer -= delta
		else:
			flash.hide()
	
		#if leftWeapon and overheatUI != null:
		#	 overheatUI.value = lerp(overheatUI.value, mech.overheatL, lerpSpd * delta)
		#else:
		#	if overheatUI2 != null:
		#		overheatUI2.value = lerp(overheatUI2.value, mech.overheatR, lerpSpd * delta)
