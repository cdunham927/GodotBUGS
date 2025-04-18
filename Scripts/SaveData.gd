extends Node

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	return save_dict


# Note: This can be called from anywhere inside the tree.  This function is path independent.
# Go through everything in the persist category and ask them to return a dict of relevant variables
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(JSON.new().stringify(node_data))
	save_game.close()
	
	
# Note: This can be called from anywhere inside the tree. This function is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://save_game.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
	# For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore the object it represents
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var test_json_conv = JSON.new()
		test_json_conv.parse(save_game.get_line())
		var current_line = test_json_conv.get_data()
		# First we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instantiate()
		get_node(current_line["parent"]).add_child(new_object)
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		# Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()
