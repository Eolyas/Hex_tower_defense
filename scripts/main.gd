extends Node3D

var tile_offset:float = 1.6
@export var tile_grass:PackedScene
@export var tower_base:PackedScene
@export var tower_archer:PackedScene
@export var monster:PackedScene
@export var tower_heart:PackedScene
var list_cart_coords:Array[Vector2]
var list_hex_coords:Array[Vector2i]
var list_outer_hex:Array[Vector2]
var pf3D:PathFollow3D
var range_terrain:int = 5
var heart:Node3D

func _ready():
	list_cart_coords = hex_grid(range_terrain)
	list_cart_coords.erase(Vector2(0,0))
	terrain_generation()
	outer_hexes()
	heart = tower_heart.instantiate()
	var hex = tile_grass.instantiate()
	$map.add_child(hex)
	hex.global_position = Vector3(0,0,0)
	hex.add_child(heart)
	heart.get_child(0).body_entered.connect(_on_heart_reached)
	spawning_range()
	$map.bake_navigation_mesh()

func _process(_delta):
	if Input.is_action_just_pressed("add_tower"):
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = $Camera3D.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + $Camera3D.project_ray_normal(mouse_pos) * 100
		var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		query.set_collide_with_areas(false)
		var collision:Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		var collided:StaticBody3D = collision.collider
		if collided.is_in_group("empty"):
			var hex:Node3D = collided.get_parent()
			var base:Node3D = tower_base.instantiate()
			hex.add_child(base)
			$map.bake_navigation_mesh()
			collided.remove_from_group("empty")
			collided.add_to_group("has_tower_base")
		elif collided.is_in_group("empty_base"):
			var tower:Node3D = tower_archer.instantiate()
			var base:Node3D = collided.get_parent()
			base.add_child(tower)
			collided.remove_from_group("empty_base")
			collided.add_to_group("has_tower")

func terrain_generation():
	for i in range(list_cart_coords.size()):
		var coords:Vector2 = list_cart_coords[i]
		var hex:Node3D = tile_grass.instantiate()
		$map.add_child(hex)
		hex.global_position = Vector3(coords.x,0,coords.y)

func hex_grid(radius:int):
	var _directions:Array[Vector2i] = [Vector2i(1,0),Vector2i(1,-1),Vector2i(0,-1),Vector2i(-1,0),Vector2i(-1,1),Vector2i(0,1)]
	var results:Array[Vector2i] = []
	for q:int in range(-radius, radius + 1):
		for r:int in range(max(-radius, -q - radius), min(radius, -q + radius) + 1):
			results.append(Vector2i(q, r))
	list_hex_coords = results
	var x:float
	var z:float
	var cartesian_coords:Array[Vector2] = []
	for vect:Vector2i in results:
		x = 2 * tile_offset * vect.x
		z = tile_offset * (2 * vect.y + vect.x)
		cartesian_coords.append(Vector2(x, z))

	return cartesian_coords

func outer_hexes():
	list_outer_hex.clear()
	var max_x:float = tile_offset*2*range_terrain*10
	for coords:Vector2 in list_cart_coords:
		var x:int = roundi(abs(coords.x)*10)
		var z:int = roundi(abs(coords.y)*10)
		if x == max_x or roundi((max_x - x)/2) == roundi(z - 10*tile_offset*range_terrain):
			list_outer_hex.append(coords)

func spawning_range():
	var spawn_pos:Array[Vector3]
	spawn_pos.resize(7)
	for hex:Vector2 in list_outer_hex:
		var x:int = roundi(10*hex.x)
		var z:int = roundi(10*hex.y)
		if x == roundi(10*tile_offset*2*range_terrain) and z == roundi(10*tile_offset*range_terrain):
			spawn_pos[0] = Vector3(hex.x,0,hex.y)
			spawn_pos[6] = Vector3(hex.x,0,hex.y)
		elif x == roundi(10*tile_offset*2*range_terrain) and -z == roundi(10*tile_offset*range_terrain):
			spawn_pos[1] = Vector3(hex.x,0,hex.y)
		elif x == 0 and -z == roundi(10*tile_offset*range_terrain*2):
			spawn_pos[2] = Vector3(hex.x,0,hex.y)
		elif -x == roundi(10*tile_offset*2*range_terrain) and -z == roundi(10*tile_offset*range_terrain):
			spawn_pos[3] = Vector3(hex.x,0,hex.y)
		elif -x == roundi(10*tile_offset*2*range_terrain) and z == roundi(10*tile_offset*range_terrain):
			spawn_pos[4] = Vector3(hex.x,0,hex.y)
		elif x == 0 and z == roundi(10*tile_offset*range_terrain*2):
			spawn_pos[5] = Vector3(hex.x,0,hex.y)
	var c3D:Curve3D = Curve3D.new()
	for point in spawn_pos:
		c3D.add_point(point)
	var p3D:Path3D = Path3D.new()
	add_child(p3D)
	p3D.curve = c3D
	pf3D = PathFollow3D.new()
	p3D.add_child(pf3D)

func _on_monster_spawn_timeout():
	pf3D.set_progress_ratio(randf())
	var mob = monster.instantiate()
	add_child(mob)
	mob.global_position = pf3D.global_position

func _on_monster_death():
	pass

func _on_heart_reached(body):
	print(body)
	print("monster reached heart")
