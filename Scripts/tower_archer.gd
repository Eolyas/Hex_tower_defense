extends Node3D

var list_monster:Array = []
@export var Parrow:PackedScene
var damage:float = 10
var attack_speed:float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cooldown.set_wait_time(1/attack_speed)


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
			var m_dist:float = list_monster[i]._get_distance_from_target().size()
			if m_dist < temp_distance:
				temp_distance = m_dist
				temp_index = i
		var arrow = Parrow.instantiate()
		add_child(arrow)
		arrow.global_position = $Marker3D.global_position
		arrow.damage = damage
		arrow.set_target(list_monster[temp_index])


func _on_area_3d_body_exited(body):
	list_monster.erase(body)

func attack_speed_add(number:float):
	attack_speed += number
	$Cooldown.set_wait_time(1/attack_speed)

func attack_speed_multi(number:float):
	attack_speed *= number
	$Cooldown.set_wait_time(1/attack_speed)
