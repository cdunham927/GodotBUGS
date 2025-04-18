extends Area2D

@export var sprites = [ preload("res://Sprites/Splats/splat00.png") ]
@onready var player

func _ready():
	player = get_parent().get_parent()
	Shuffle()
	
func Shuffle():
	sprites.shuffle()
	$Sprite2D.texture = sprites[0]

func _on_HoneySplat_body_entered(body):
	if body.is_in_group("Player"):
		body.GetShit()
		
func _on_Timer_timeout():
	queue_free()

func _on_Shit_body_exited(body):
	if body.is_in_group("Player"):
		body.RedShit()
