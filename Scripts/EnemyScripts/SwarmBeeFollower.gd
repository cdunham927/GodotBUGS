extends Area2D

#lerp sprite
onready var spr = get_parent()

var spawnPos : Vector2
export(float) var lerpSpd = 10.0
export(float) var lerpVariation = 0.1

export(float) var maxHp = 35.0
var hp : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHp
	get_parent().get_parent().get_parent().hp += maxHp
	#print("Parent hp: ", get_parent().get_parent().get_parent().hp)
	
	lerpSpd = lerpSpd + rand_range(0, lerpVariation)
	spawnPos = position

func _process(delta):
	position = lerp(position, spawnPos, lerpSpd * delta)

func Damage(amt):
	get_parent().get_parent().get_parent().Damage(amt)
	#print("Damaging single bee")
	hp -= amt

	if hp <= 0:
		get_parent().queue_free()

func FireDamage():
	get_parent().get_parent().get_parent().FireDamage(5)
	#print("Damaged")
	#if $AnimationPlayer.current_animation != "AttackIndicator":
	#	play_anim("Hit")
	#if curState == States.idle or curState == States.patrol:
	#	ChangeState(States.chase)
	hp -= 5
	
	if hp <= 0:
		get_parent().queue_free()
