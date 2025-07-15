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
	if not list_monster.has(body):
		list_monster.append(body)


func _on_cooldown_timeout():
	if list_monster != []:
		var temp_index:int = 0
		var temp_distance:float = 0
		for i in range(list_monster.size()):
			var m_dist:float = list_monster[i].global_position - global_position
			if m_dist > temp_distance:
				temp_distance = m_dist
				temp_index = i
		var arrow = Parrow.instantiate()
		add_child(arrow)
		arrow.global_position = $Marker3D.global_position
		arrow.set_target(list_monster[temp_index])


func _on_area_3d_body_exited(body):
	list_monster.erase(body)
