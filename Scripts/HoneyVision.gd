extends Node2D

@export var sprites = [ preload("res://Sprites/Splats/splat00.png") ]
@onready var player

func _ready():
	player = get_parent().get_parent()
	Shuffle()
	
func _process(delta):
	if player.honeyed < 25 and player.honeyed > 0:
		modulate.a = player.honeyed / 200
	elif player.honeyed >= 25:
		modulate.a = 0.5
	else:
		modulate.a = 0
	pass

func Shuffle():
	sprites.shuffle()
	$Sprite2D.texture = sprites[0]
