extends Node2D

var paused : bool = false
onready var pauseMenu = get_node("/root/World/PauseRoot")
onready var victoryMenu = get_node("/root/World/VictoryRoot")

enum GameStates { ant, bee, beetle, spider }
export var curState : int = GameStates.ant

onready var gameStatusText = $UI/Label

#Ant level variables
export(int) var numAntHills
var deadHills : int = 0


#Bee level variables

#Beetle level variables

#Spider level variables

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
			pass
		GameStates.spider:
			pass
		
func Victory():
	victoryMenu.show()
	var con = $VictoryRoot/BG/VBoxContainer/ContinueButton
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
		var res = $PauseRoot/CenterContainer/VBoxContainer/VBoxContainer/ContinueButton
		res.grab_focus()
		pauseMenu.show()
	#paused = true
	#get_tree().paused = true
	#pauseMenu.show()
