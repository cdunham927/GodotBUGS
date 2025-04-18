extends Node2D

var paused : bool = false
@onready var pauseMenu = get_node("/root/World/PauseRoot")
@onready var victoryMenu = get_node("/root/World/VictoryRoot")

enum GameStates { ant, bee, beetle, spider }
@export var curState : int = GameStates.ant

@onready var gameStatusText = $UI/Label

#Ant level variables
@export var numAntHills: int
var deadHills : int = 0

#Spider level variables
@export var numSpiders: int
var deadSpiders : int = 0

func _init():
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		# Now we can call our save function on each node.
	load_game()
	pass

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Pause()
	
	match (curState):
		GameStates.ant:
			gameStatusText.text = "Destroy Anthills: " +  str(deadHills) + "/"  + str(numAntHills)
			if deadHills >= numAntHills:
				Victory()
		GameStates.bee:
			gameStatusText.text = "Kill Queen Bee"
		GameStates.beetle:
			gameStatusText.text = "Destroy Spawner"
		GameStates.spider:
			gameStatusText.text = "Destroy all " + str(numSpiders) + " spiders"
			if numSpiders <= 0:
				Victory()
				
	if Input.is_key_pressed(KEY_O):
		Victory()
		
func Victory():
	victoryMenu.show()
	var con = $VictoryRoot/Control/BG/VBoxContainer/ContinueButton
	con.grab_focus()
	get_tree().paused = true
	pass
 
func Pause():
	if paused:
		paused = false
		get_tree().paused = false
		pauseMenu.hide()
	else:
		paused = true
		get_tree().paused = true
		var res = $PauseRoot/Control/CenterContainer/VBoxContainer/VBoxContainer/ContinueButton
		res.grab_focus()
		pauseMenu.show()
	#paused = true
	#get_tree().paused = true
	#pauseMenu.show()

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.

var savePath = "user://savegame.dat"

func save_game():
	var save_game = File.new()
	var error = save_game.open(savePath, File.WRITE)
	if error == OK:
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		for node in save_nodes:
			# Check the node is an instanced scene so it can be instanced again during load.
			#if node.filename.empty():
			#	print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			#	continue

			# Check the node has a save function.
			#if !node.has_method("save"):
			#	print("persistent node '%s' is missing a save() function, skipped" % node.name)
			#	continue

			# Call the node's save function.
			var node_data = node.call("save")
			save_game.store_var(node.save_dict)

			# Store the save dictionary as a new line in the save file.
			#save_game.store_line(to_json(node_data))
		save_game.close()
	
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if save_game.file_exists(savePath):
		var error = save_game.open(savePath, File.READ)
		if error == OK:
			var player_data = save_game.get_var()
			save_game.close()
			
			
		# We need to revert the game state so we're not cloning objects
		# during loading. This will vary wildly depending on the needs of a
		# project, so take care with this step.
		# For our example, we will accomplish this by deleting saveable objects.
			#var save_nodes = get_tree().get_nodes_in_group("Persist")
			#for i in save_nodes:
			#	i.queue_free()

		# Load the file line by line and process that dictionary to restore
		# the object it represents.
			#save_game.open(savePath, File.READ)
			#while save_game.get_position() < save_game.get_len():
				# Get the saved dictionary from the next line in the save file
			#	var node_data = parse_json(save_game.get_line())

			# Firstly, we need to create the object and add it to the tree and set its position.
			#	var new_object = load(node_data["filename"]).instance()
			#	get_node(node_data["parent"]).add_child(new_object)
				#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
	
				# Now we set the remaining variables.
			#	for i in node_data.keys():
			#		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			#			continue
			#		new_object.set(i, node_data[i])



func _on_Timer_timeout():
	#load_game()
	pass
