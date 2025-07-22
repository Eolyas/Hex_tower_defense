extends Node3D

var main:Node3D
var list_tile:Array[Node3D]
@export var Pexplosion:PackedScene
var damage:float = 5
var attack_speed:float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()
	list_tile = main.list_tile
	$Cooldown.set_wait_time(1/attack_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cooldown_timeout():
	var temp_list:Array[Node3D] = []
	for tile:Node3D in list_tile:
		if tile.is_in_group("has_monster"):
			temp_list.append(tile)
	if temp_list:
		var target:Node3D = temp_list.pick_random()
		var explosion = Pexplosion.instantiate()
		add_child(explosion)
		explosion.damage = damage
		explosion.global_position = target.global_position
		await get_tree().create_timer(2.0).timeout
		explosion.queue_free()
	
	
func _body_entered_on_tile(_body:Node3D):
	pass
	
func attack_speed_add(number:float):
	attack_speed += number
	$Cooldown.set_wait_time(1/attack_speed)

func attack_speed_multi(number:float):
	attack_speed *= number
	$Cooldown.set_wait_time(1/attack_speed)
