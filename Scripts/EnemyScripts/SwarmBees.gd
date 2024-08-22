extends "res://Scripts/EnemyScripts/Enemy.gd"

export(float) var spdIncrease = 50.0

func _ready():
	Setup()
	
	hp = $SpriteParent/Sprite/LilBeeBich.maxHp * $SpriteParent.get_child_count()

func Damage(amt):
	spd += spdIncrease
	
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator" and amt >= flashMinDmg:
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
	hp -= amt
	#print("Damage dealt: ", amt)
	#print(hp)
	
	if hp <= 0:
		kill()

func FireDamage(amt = 1):
	get_parent().get_parent().get_parent().FireDamage(5)
	
	#print("Damaged")
	if $AnimationPlayer.current_animation != "AttackIndicator":
		play_anim("Hit")
	if curState == States.idle or curState == States.patrol:
		ChangeState(States.chase)
	hp -= amt
	#print("Damage dealt: ", amt)
	#print(hp)
	
	if hp <= 0:
		kill()

func DamageChild():
	#var numToKill = randi(3)
	
	pass

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		var totDmg = atk * $SpriteParent.get_child_count()
		#print(totDmg)
		body.Damage(totDmg)
		#DamageChild(totDmg)
		Damage(totDmg)
