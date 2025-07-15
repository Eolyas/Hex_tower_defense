extends Node3D

var main:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cooldown_timeout():
	var list_monster:Array[Node] = main.find_children("Monster")
	var monster:CharacterBody3D = list_monster.pick_random()
	
