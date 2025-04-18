extends CPUParticles2D

@onready var soundSrc = $Stream
@export var soundName: String = "MetalCling"
var hit
	
func _ready():
	hit = load("res://Audio/SFX/" + soundName + ".mp3")
	play_sound(true)

@export var pitchLow: float = 0.6
@export var pitchHigh: float = 1.5
func play_sound(pitched = false):
	#if !canPlay:
	#	canPlay = true
	#	return
	if pitched:
		soundSrc.pitch_scale = randf_range(pitchLow, pitchHigh)
	else:
		soundSrc.pitch_scale = 1.0
	soundSrc.stream = hit
	soundSrc.play()

func _on_Timer_timeout():
	queue_free()
