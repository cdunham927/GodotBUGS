extends KinematicBody2D

export(float) var hp = 4
export var spd = 200
export var atk = 5
 
onready var raycast = $RayCast2D
onready var anim = $AnimationPlayer
 
var player = null
var inSight : bool = false

enum States { idle, chase, attack }
var curState : int = States.idle
 
func _ready():
	add_to_group("enemies")
	#params: name, blend, play speed
	anim.play("move", 1, 2)
 
func _physics_process(delta):
	if player == null:
		return
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	global_rotation = atan2(vec_to_player.y, vec_to_player.x) + 89.5
	move_and_collide(vec_to_player * spd * delta)
 
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll.name == "Player" and player.iframes <= 0:
			#print("Hitting player")
			coll.Damage(atk)
 
func Damage(amt):
	hp -= amt
	
	if hp <= 0:
		kill()

func kill():
	queue_free()
 
func set_player(p):
	player = p

func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)


#func _on_Head_body_entered(body):
	#Damage(body.atk / 3)


func _on_Area2D_body_entered(body):
	inSight = true


func _on_Area2D_body_exited(body):
	inSight = false
