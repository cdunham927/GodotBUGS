extends "res://Scripts/PlayerScripts/WeaponController.gd"

func Shoot():
	$Area2D.monitoring = true
	$FlamethrowerFire2.emitting = true
	#ShowFlash()
	#curShotTime = timeBetweenShots
	overheat += incAmt
	
	get_tree().current_scene.get_node("Camera2D").add_trauma(0.01)
	
	if overheat >= overheatTotal + incAmt:
		recover = recoverTime

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
		if leftWeapon and Input.is_action_pressed("attack") and curShotTime <= 0 and recover <= 0:
			#shooting = true
			tilNotShooting = tilNotShootingMin
			Shoot()
		#Left weapon stop shooting
		if leftWeapon and Input.is_action_just_released("attack"):
			$Area2D.monitoring = false
			$FlamethrowerFire2.emitting = false
			tilNotShooting = tilNotShootingMin
		#Right weapon start shooting
		if leftWeapon == false and Input.is_action_pressed("attacktwo") and curShotTime <= 0 and recover <= 0:
			#shooting = true
			tilNotShooting = tilNotShootingMin
			Shoot()
		#Right weapon stop shooting
		if leftWeapon == false and Input.is_action_just_released("attacktwo"):
			$Area2D.monitoring = false
			$FlamethrowerFire2.emitting = false
			tilNotShooting = tilNotShootingMin
		
	#if tilNotShooting <= 0:
	#	shooting = false
	
		if overheat <= 0 and overheatUI != null and overheatUI2 != null:
			if leftWeapon:
				overheatUI.hide()
			else:
				overheatUI2.hide()
		else:
			if overheatUI != null and overheatUI2 != null:
				if leftWeapon:
					overheatUI.show()
				else:
					overheatUI2.show()

		if recover <= 0 and tilNotShooting <= 0 and overheat > 0:
			overheat -= delta * recoveryModifier
	#Decrement nums
		if recover > 0 and overheatUI != null and overheatUI2 != null:
			if leftWeapon:
				overheatUI.tint_progress = overheatColor
			else:
				overheatUI2.tint_progress = overheatColor
			recover -= delta
		else:
			if overheatUI != null and overheatUI2 != null:
				if leftWeapon:
					overheatUI.tint_progress = goodColor
				else:
					overheatUI2.tint_progress = goodColor
		if tilNotShooting > 0:
			tilNotShooting -= delta
		if curShotTime > 0:
			curShotTime -= delta
		if flashTimer > 0:
			flashTimer -= delta
		else:
			flash.hide()
	
		if leftWeapon and overheatUI != null:
			 overheatUI.value = lerp(overheatUI.value, overheat, lerpSpd * delta)
		else:
			if overheatUI2 != null:
				overheatUI2.value = lerp(overheatUI2.value, overheat, lerpSpd * delta)
