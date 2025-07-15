extends Node3D

var main:Node3D
var list_tile:Array[Node]
@export var Pexplosion:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()
	print(main)
	list_tile = main.find_children("Tile")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cooldown_timeout():
	print(list_tile)
	var temp_list:Array[Node] = []
	for tile in list_tile:
		if tile.is_in_group("has_monster"):
			print("there is one with monsters")
			temp_list.append(tile)
	if temp_list:
		print("I'm casting!!!")
		var target:Node = temp_list.pick_random()
		var explosion = Pexplosion.instantiate()
		add_child(explosion)
		explosion.global_position = target.global_position
		await get_tree().create_timer(2.0).timeout
		explosion.queue_free()
	
	
func _body_entered_on_tile(_body:Node3D):
	pass
