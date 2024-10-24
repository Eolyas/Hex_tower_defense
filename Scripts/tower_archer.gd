extends Node3D

var list_monster:Array = []
@export var Parrow:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if list_monster.find(body) == -1:
		print("monster added")
		list_monster.append(body)


func _on_cooldown_timeout():
	if list_monster != []:
		var arrow = Parrow.instantiate()
		add_child(arrow)
		arrow.global_position = $Marker3D.global_position
		arrow.set_target(list_monster[0])


func _on_area_3d_body_exited(body):
	list_monster.erase(body)
	print("monster removed")
