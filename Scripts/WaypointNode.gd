extends Node2D

var player

onready var leftWaypoint = $Path2DL/PathFollowerL
onready var rightWaypoint = $Path2DR/PathFollowerR
onready var upperWaypoint = $Path2DU/PathFollowerU
onready var lowerWaypoint = $Path2DD/PathFollowerD

export var currentWaypoint = false

export(PackedScene) var levelToLoad

export var moving : bool = false

func _ready():
	player = get_node("/root/World/OverworldPlayer")
	
	if currentWaypoint:
		#player.global_position = global_position
		pass

func _process(delta):
	if player == null:
		#print("null player")
		player = get_node("/root/World/OverworldPlayer")
	
	if player != null and !leftWaypoint.active and currentWaypoint and Input.is_action_just_pressed("move_left"):
		#Move player to next waypoint
		leftWaypoint.set_offset(0)
		player.get_parent().remove_child(player)
		leftWaypoint.add_child(player)
		leftWaypoint.active = true
		moving = true
		currentWaypoint = false
	
	if player != null and !rightWaypoint.active and currentWaypoint and Input.is_action_just_pressed("move_right"):
		#Move player to next waypoint
		rightWaypoint.set_offset(0)
		player.get_parent().remove_child(player)
		rightWaypoint.add_child(player)
		rightWaypoint.active = true
		moving = true
		currentWaypoint = false
	
	if player != null and !upperWaypoint.active and currentWaypoint and Input.is_action_just_pressed("move_up"):
		#Move player to next waypoint
		upperWaypoint.set_offset(0)
		player.get_parent().remove_child(player)
		upperWaypoint.add_child(player)
		upperWaypoint.active = true
		moving = true
		currentWaypoint = false
	
	if player != null and !lowerWaypoint.active and currentWaypoint and Input.is_action_just_pressed("move_down"):
		#Move player to next waypoint
		lowerWaypoint.set_offset(0)
		player.get_parent().remove_child(player)
		lowerWaypoint.add_child(player)
		lowerWaypoint.active = true
		moving = true
		currentWaypoint = false
		
	if player != null and currentWaypoint and Input.is_action_just_pressed("select"):
		print("Loading level")
		LoadLevel()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and currentWaypoint == false and moving == false:
		#print("Damaged by: ", curAtk)
		print("Setting new waypoint")
		currentWaypoint = true

func LoadLevel():
	var l = levelToLoad.instance()
	get_node("/root").add_child(l)
	var w = get_node("/root/World")
	w.queue_free()

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		#currentWaypoint = false
		pass
