extends Node2D

var hasActivated = false
export(NodePath) var nextArea
#export(NodePath) var previousArea
#export(Array, NodePath) var walls := []
var next
#var prev

func _ready():
	hasActivated = false
	next = get_node(nextArea)
	#prev = get_node(previousArea)
	
	for ch in next.get_children():
		ch.paused = true
		ch.hide()
		ch.set_process(false)
		ch.set_physics_process(false)
	
	#Deactivate next part of map automatically
	#next.get_tree().paused = true
	next.set_process(false)
	next.set_physics_process(false)
	

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !hasActivated:
		#print("activating")
		next.show()
		next.set_process(true)
		next.set_physics_process(true)
		
		for ch in next.get_children():
			ch.paused = false
			ch.show()
			ch.set_process(true)
			ch.set_physics_process(true)
			
		#prev.set_process(false)
		#prev.hide()
		hasActivated = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and !hasActivated:
		#print("activating")
		next.show()
		next.set_process(true)
		
		for ch in next.get_children():
			ch.paused = false
			ch.show()
			ch.set_physics_process(true)
			ch.set_process(true)
			
		#prev.set_process(false)
		#prev.hide()
		hasActivated = true
