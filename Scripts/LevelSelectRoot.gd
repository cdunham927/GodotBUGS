extends CanvasLayer

#onready var menu = load("res://menu.tscn").instance()
onready var world = load("res://Scenes/Levels/Overworld.tscn")
onready var antLevel = load("res://Scenes/Levels/MainLevels/AntLevel.tscn")
onready var beetleLevel = load("res://Scenes/Levels/MainLevels/BeetleLevel.tscn")
onready var beeLevel = load("res://Scenes/Levels/MainLevels/BeeLevel.tscn")
onready var spiderLevel = load("res://Scenes/Levels/MainLevels/SpiderLevel.tscn")

var menuSwitch = preload("res://Audio/UIFX/220168__gameaudio__button-spacey-confirm.wav")
var click = preload("res://Audio/UIFX/220175__gameaudio__pop-click.wav")
export var canPlay : bool = false

func _on_ContinueButton_pressed():
	#Ant Level
	var game = antLevel.instance()
	get_tree().get_root().add_child(game)
	#queue_free()
	hide()
	
	play_sound(click, true)

func _on_NewGameButton_pressed():
	#Beetle Level
	var game = beetleLevel.instance()
	get_tree().get_root().add_child(game)
	queue_free()
	
	
	play_sound(click, true)

func _on_OptionsButton_pressed():
	#Bee Level
	var game = beeLevel.instance()
	get_tree().get_root().add_child(game)
	queue_free()
	
	
	play_sound(click, true)

func _on_QuitButton_pressed():
	#Spider Level
	var game = spiderLevel.instance()
	get_tree().get_root().add_child(game)
	get_parent().save_game()
	play_sound(click, true)
	queue_free()
	
export(float) var pitchLow = 0.8
export(float) var pitchHigh = 1.3
func play_sound(snd, pitched = false):
	if !canPlay:
		canPlay = true
		return
	if pitched:
		$MenuParent/AudioStreamPlayer.pitch_scale = rand_range(pitchLow, pitchHigh)
	$MenuParent/AudioStreamPlayer.stream = snd
	$MenuParent/AudioStreamPlayer.play()

func _on_ContinueButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_NewGameButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_OptionsButton_focus_entered():
	play_sound(menuSwitch, true)

func _on_QuitButton_focus_entered():
	play_sound(menuSwitch, true)

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_game = File.new()
	save_game.open("res://savegame.data", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
	
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.data"):
		print("No save found from menu")
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://savegame.data", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])

	save_game.close()


func _on_Timer_timeout():
	#load_game()
	pass
