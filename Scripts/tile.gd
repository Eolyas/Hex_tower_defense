extends Node3D

var list_monster:Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tile_shape_body_entered(body):
	if body.is_in_group("monster"):
		add_to_group("has_monster")
		list_monster.append(body)


func _on_tile_shape_body_exited(body):
	if list_monster.has(body):
		remove_from_group("has_monster")
		list_monster.erase(body)
