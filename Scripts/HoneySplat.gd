extends Area2D

export(float) var honeyAmt = 25.0
export(float) var spd = 50.0
export var moves : bool = false

export var sprites = [ preload("res://Sprites/Splats/splat00.png") ]
onready var player

func _ready():
	player = get_parent().get_parent()
	Shuffle()
	
func Shuffle():
	sprites.shuffle()
	$Sprite.texture = sprites[0]


func _on_HoneySplat_body_entered(body):
	if body.is_in_group("Player"):
		body.GetHoneyed(honeyAmt)
		queue_free()
		
func _process(delta):
	if moves:
		position.y -= spd * delta


func _on_Timer_timeout():
	moves = false
