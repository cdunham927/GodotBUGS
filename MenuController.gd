extends Control

#onready var menu = load("res://menu.tscn").instance()
onready var world = load("res://Scenes/Levels/World.tscn")

func _on_ContinueButton_pressed():
	#Load save file
	
	#For now, load main level
	
	#This way hides the current scene
	var game = world.instance()
	get_tree().get_root().add_child(game)
	queue_free()
	#hide ()
	
	#var game = world.instance()
	#get_tree().get_root().add_child(game)
	#hide ()
	pass # Replace with function body.
	

func _on_NewGameButton_pressed():
	pass # Replace with function body.


func _on_OptionsButton_pressed():
	pass # Replace with function body.

#func _ready():
#	add_child(menu)

#func _on_remove_child_button_pressed():
#	remove_child(menu)
	
#func _on_add_child_button_pressed():
#	add_child(menu)

