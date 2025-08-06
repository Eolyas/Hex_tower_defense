extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_exited(body):
	print("body left area")
	if body.is_in_group("monster"):
		if randi_range(0,10) > 5:
			get_parent_node_3d().get_parent_node_3d().get_parent_node_3d().soul_variation(1)
