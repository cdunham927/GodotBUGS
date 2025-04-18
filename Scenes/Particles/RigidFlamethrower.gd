extends Node2D

@export var emit = false

func _process(delta):
	$RigidBodyParticles2D.emitting = emit
