extends Sprite

var spawnPos : Vector2
export(float) var lerpSpd = 10.0
export(float) var lerpVariation = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	lerpSpd = lerpSpd + rand_range(0, lerpVariation)
	spawnPos = position

func _process(delta):
	position = lerp(position, spawnPos, lerpSpd * delta)
