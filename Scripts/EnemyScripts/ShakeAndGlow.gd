extends Node2D

var startPos : Vector2 = Vector2(0, 0)
var localPos : Vector2 = Vector2(0, 0)
export(float) var dis = 1.0
export(float) var spd = 10.0
var spdRand = 5.0
var n : float = 0.0
export(bool) var offset = false
var randDegree : float = 0.0
var disRand : float = 0.0
export(float) var degreeVariability = 360.0
export(float) var speedVariability = 5.0
export(float) var distanceVariability = 5.0
export(float) var spdIncrease = 2.0
export(float) var clrIncrease = 15.0
var opposite : bool = false


func _ready():
	randomize()
	var o = rand_range(0, 1)
	if o > 0.5:
		opposite = true
	else:
		opposite = false
		
	spdRand = rand_range(0, speedVariability)
	randDegree = rand_range(0, degreeVariability)
	disRand = rand_range(0, distanceVariability)
	startPos = global_position
	localPos = position

func _process(delta):
	n += delta
	if spd > 0:
		var col = 0.0
		col = lerp(col, 1.0, spd / clrIncrease)
		$Sprite.material.set_shader_param("mix_amount", col)
		
		if opposite:
			if offset:
				position = Vector2(startPos.x + ((dis + disRand) * sin(deg2rad(delta + randDegree) + (n * (spd + spdRand)))), startPos.y + ((dis + disRand) * cos(deg2rad(delta + randDegree) + (n * spd))))
			else:
				position = Vector2(localPos.x + ((dis + disRand) * sin(deg2rad(delta) + (n * (spd + spdRand)))), localPos.y + ((dis + disRand) * cos(deg2rad(delta) + (n * spd))))
		else:
			if offset:
				position = Vector2(startPos.x - ((dis + disRand) * sin(deg2rad(delta + randDegree) + (n * (spd + spdRand)))), startPos.y - ((dis + disRand) * cos(deg2rad(delta + randDegree) + (n * spd))))
			else:
				position = Vector2(localPos.x - ((dis + disRand) * sin(deg2rad(delta) + (n * (spd + spdRand)))), localPos.y - ((dis + disRand) * cos(deg2rad(delta) + (n * spd))))
