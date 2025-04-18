extends Node2D

var startPos : Vector2 = Vector2(0, 0)
var localPos : Vector2 = Vector2(0, 0)
@export var dis: float = 1.0
@export var spd: float = 10.0
var spdRand = 5.0
var n : float = 0.0
@export var offset: bool = false
var randDegree : float = 0.0
var disRand : float = 0.0
@export var degreeVariability: float = 360.0
@export var speedVariability: float = 5.0
@export var distanceVariability: float = 5.0
var opposite : bool = false


func _ready():
	randomize()
	var o = randf_range(0, 1)
	if o > 0.5:
		opposite = true
	else:
		opposite = false
		
	spdRand = randf_range(0, speedVariability)
	randDegree = randf_range(0, degreeVariability)
	disRand = randf_range(0, distanceVariability)
	startPos = global_position
	localPos = position

func _process(delta):
	n += delta
	if opposite:
		if offset:
			position = Vector2(startPos.x + ((dis + disRand) * sin(deg_to_rad(delta + randDegree) + (n * (spd + spdRand)))), startPos.y + ((dis + disRand) * cos(deg_to_rad(delta + randDegree) + (n * spd))))
		else:
			position = Vector2(localPos.x + ((dis + disRand) * sin(deg_to_rad(delta) + (n * (spd + spdRand)))), localPos.y + ((dis + disRand) * cos(deg_to_rad(delta) + (n * spd))))
	else:
		if offset:
			position = Vector2(startPos.x - ((dis + disRand) * sin(deg_to_rad(delta + randDegree) + (n * (spd + spdRand)))), startPos.y - ((dis + disRand) * cos(deg_to_rad(delta + randDegree) + (n * spd))))
		else:
			position = Vector2(localPos.x - ((dis + disRand) * sin(deg_to_rad(delta) + (n * (spd + spdRand)))), localPos.y - ((dis + disRand) * cos(deg_to_rad(delta) + (n * spd))))
