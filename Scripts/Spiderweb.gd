extends Area2D

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
		body.Webbed()
		queue_free()
		

func _on_Timer_timeout():
	queue_free()
