extends Node3D

@export var life:int = 20
@export var gold:int = 100
var soul_counter:int = 0
var current_tower:String
var wave_counter:int = 0
var r_dist:float = 22.2
var q_dist:float = 19.2
var s_dist:float = 11.1
@export var Ptile:PackedScene
@export var Ptower_base:PackedScene
@export var Ptower_heart:PackedScene
@export var Pmonster:PackedScene
@export var Ptower_archer:PackedScene
@export var Ptower_area:PackedScene
@export var Ptower_sniper:PackedScene
@export var Ptower_random:PackedScene
@export var Psoul_collector:PackedScene
var list_augment:Dictionary

var astar:AStar3D = AStar3D.new()
var axial:Array[Vector3i] = [Vector3i(-1,1,0),Vector3i(1,-1,0),Vector3i(0,1,-1),Vector3i(-1,0,1),Vector3i(1,0,-1),Vector3i(0,-1,1)]
var axial_coordinates:Array[Vector3i]
var list_tile:Array[Node3D]
var list_tower:ItemList

func _ready():
	$UI/life_counter.set_text("Life : " + str(life))
	$UI/gold.set_text("Gold : " + str(gold))
	$UI/wave.set_text("Wave : " + str(wave_counter))
	$UI/soul_counter.set_text("Souls : " + str(soul_counter))
	$UI/button_master/button_n.pressed.connect(_on_button_n_pressed)
	$UI/button_master/button_s.pressed.connect(_on_button_s_pressed)
	$UI/button_master/button_ne.pressed.connect(_on_button_ne_pressed)
	$UI/button_master/button_nw.pressed.connect(_on_button_nw_pressed)
	$UI/button_master/button_se.pressed.connect(_on_button_se_pressed)
	$UI/button_master/button_sw.pressed.connect(_on_button_sw_pressed)
	list_tower = $UI/list_tower
	list_tower.item_clicked.connect(_on_list_tower_clicked)
	list_tower.add_item("Tower")
	list_tower.add_item("Archer")
	list_tower.add_item("Area")
	list_tower.add_item("Sniper")
	list_tower.add_item("Random")
	list_tower.add_item("Soul_collector")
	create_main_isle()
	var heart = Ptower_heart.instantiate()
	add_child(heart)
	heart.global_position = Vector3(0,0,0)

func _process(_delta):
	if Input.is_action_just_pressed("add_tower"):
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = $Marker3D/Camera3D.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + $Marker3D/Camera3D.project_ray_normal(mouse_pos) * 1000
		var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		query.set_collide_with_areas(true)
		var collision:Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		if collision:
			var entity:Node3D = collision.collider.get_parent_node_3d()
			if entity.is_in_group("empty"):
				if entity.is_in_group("tile"):
					if current_tower == "Tower":
						var tower_base = Ptower_base.instantiate()
						entity.add_child(tower_base)
						entity.remove_from_group("empty")
						tower_base.add_to_group("empty")
						tower_base.add_to_group("tower_base")
						astar.set_point_disabled(astar.get_closest_point(entity.global_position))
						entity.remove_from_group("empty")
				elif entity.is_in_group("tower_base"):
					if current_tower == "Archer":
						var tower = Ptower_archer.instantiate()
						entity.add_child(tower)
						entity.remove_from_group("empty")
					elif current_tower == "Area":
						var tower = Ptower_area.instantiate()
						entity.add_child(tower)
						entity.remove_from_group("empty")
					elif current_tower == "Sniper":
						var tower = Ptower_sniper.instantiate()
						entity.add_child(tower)
						entity.remove_from_group("empty")
					elif current_tower == "Random":
						var tower = Ptower_random.instantiate()
						entity.add_child(tower)
						entity.remove_from_group("empty")
					elif current_tower == "Soul_collector":
						var tower = Psoul_collector.instantiate()
						entity.add_child(tower)
						entity.remove_from_group("empty")
		
	#if Input.is_action_just_pressed("add_monster"):
		#var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		#var origin:Vector3 = $Main_island/Marker3D/Camera3D.project_ray_origin(mouse_pos)
		#var end:Vector3 = origin + $Main_island/Marker3D/Camera3D.project_ray_normal(mouse_pos) * 1000
		#var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		#query.set_collide_with_areas(true)
		#var collision:Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		#if collision:
			#var entity = collision.collider.get_parent_node_3d()
			#if entity.is_in_group("tile") and entity.is_in_group("empty"):
				#summon_monster(entity.global_position,)

func create_main_isle():
	var radius:int = 3
	for r:int in range(-radius,radius+1):
		for q:int in range(-radius,radius+1):
			for s:int in range(-radius,radius+1):
				if r+q+s == 0:
					axial_coordinates.append(Vector3i(r,q,s))
	for i in axial_coordinates:
		var real_coor = axial_to_carth(i)
		var index:String = get_astar_index(i)
		astar.add_point(int(index),real_coor+Vector3(0,5,0))
		var tile = Ptile.instantiate()
		list_tile.append(tile)
		add_child(tile)
		tile.global_position = real_coor
		tile.add_to_group("empty")
	var regex = RegEx.new()
	regex.compile("(\\d)(\\d{2})")
	for i in astar.get_point_ids():
		var matches = regex.search_all(str(i))
		var result:Array[int] = []
		for matche in matches:
			if matche.get_string(1) == "1": 
				result.append(int(matche.get_string(2)))
			else: 
				result.append(int(matche.get_string(2))*-1)
		var index:Vector2i = Vector2i(result[0],result[1])
		for j in axial:
			j += Vector3i(index.x,index.y,0)
			var index_n:String = get_astar_index(j)
			if not astar.are_points_connected(i,int(index_n)) and astar.has_point(int(index_n)):
				astar.connect_points(i,int(index_n))

func life_loss(damage:int):
	life -= damage
	$UI/life_counter.set_text("Life : " + str(life))

func soul_variation(number:int):
	soul_counter += number
	$UI/soul_counter.set_text("Souls : " + str(soul_counter))

func summon_monster(pos:Vector3):
	var monster = Pmonster.instantiate()
	monster.set_position(pos+Vector3(0,5,0))
	add_child(monster)
	monster.summon()

func create_isle(vector_ax:Vector3i):
	var tile:Node3D = Ptile.instantiate()
	var vector:Vector3 = axial_to_carth(vector_ax)
	tile.set_position(vector)
	add_child(tile)
	var castle:Node3D = Ptower_base.instantiate()
	tile.add_child(castle)
	list_tile.append(tile)
	axial_coordinates.append(carth_to_axial(vector))
	var index:int = int(get_astar_index(vector_ax))
	astar.add_point(int(index),vector+Vector3(0,5,0))
	var list_neighbours:Array = axial.map(func(element): return element + vector_ax)
	for i:Vector3i in list_neighbours:
		var ind:int = int(get_astar_index(i))
		if astar.has_point(ind):
			if not astar.are_points_connected(ind,index):
				astar.connect_points(index,ind)
	wave_start(vector,castle)

func axial_to_carth(coord:Vector3i):
	return Vector3(coord.x*r_dist+coord.y*s_dist,0,coord.y*q_dist)

func carth_to_axial(coord:Vector3):
	var q:int = roundi(coord.z/q_dist)
	var r:int = roundi((coord.x-q*s_dist)/r_dist)
	var s:int = -r-q
	return Vector3i(r,q,s)

func get_astar_index(vector_ax:Vector3i):
	var index:String = ""
	if vector_ax.x < 0:
		index += "20"
	else:
		index += "10"
	index += str(abs(vector_ax.x))
	if vector_ax.y < 0:
		index += "20"
	else:
		index += "10"
	index += str(abs(vector_ax.y))
	return index

func _on_button_n_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x-1,coord.y,coord.z+1) in axial_coordinates and Vector3i(coord.x,coord.y-1,coord.z+1) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x,coord.y-1,coord.z+1))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func _on_button_s_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x-1,coord.y,coord.z+1) in axial_coordinates and Vector3i(coord.x-1,coord.y+1,coord.z) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x-1,coord.y+1,coord.z))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func _on_button_ne_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x,coord.y-1,coord.z+1) in axial_coordinates and Vector3i(coord.x+1,coord.y-1,coord.z) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x+1,coord.y-1,coord.z))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func _on_button_nw_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x-1,coord.y+1,coord.z) in axial_coordinates and Vector3i(coord.x-1,coord.y,coord.z+1) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x-1,coord.y,coord.z+1))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func _on_button_se_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x-1,coord.y+1,coord.z) in axial_coordinates and Vector3i(coord.x,coord.y+1,coord.z-1) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x,coord.y+1,coord.z-1))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func _on_button_sw_pressed():
	var list_available_coord:Array[Vector3i] = []
	for coord in axial_coordinates:
		if Vector3i(coord.x,coord.y-1,coord.z+1) in axial_coordinates and Vector3i(coord.x-1,coord.y,coord.z+1) not in axial_coordinates:
			list_available_coord.append(Vector3i(coord.x-1,coord.y,coord.z+1))
	if list_available_coord:
		create_isle(list_available_coord.pick_random())
	else:
		print("no possible room for island")

func wave_start(coord:Vector3,castle:Node3D):
	var counter:int = 0
	for child in get_children():
		if child.is_in_group("monster"):
			counter += 1
	add_gold(10*counter)
	wave_counter += 1
	for i in wave_counter:
		summon_monster(coord)
		await get_tree().create_timer(2.0).timeout
	await get_tree().create_timer(5.0).timeout
	castle.queue_free()

func add_gold(quantity:int):
	gold += quantity
	$UI/gold.set_text("Gold : " + str(gold))

func _on_list_tower_clicked(index,_pos,_mouse_button):
	current_tower = list_tower.get_item_text(index)
