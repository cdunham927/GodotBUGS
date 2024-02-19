extends Sprite

onready var lookOff = $LookOffset
onready var world = get_node("/root/World/")
var move_vec : Vector2
export var posOffset : float = 1
export var offsetZ : float = 89.5
export var rotSpd : float = 0.03

func _ready():
	self.remove_child(lookOff)
	world.add_child(lookOff)

func _process(delta):
	move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if (move_vec.x != 0 or move_vec.y != 0):
		lookOff.global_position = Vector2(global_position.x + move_vec.x * posOffset, global_position.y + move_vec.y * posOffset)
	
		var look_vec = lookOff.global_position - global_position
		global_rotation = lerp_angle(global_rotation, atan2(look_vec.y, look_vec.x) + offsetZ, rotSpd)
	
