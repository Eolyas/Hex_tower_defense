extends CharacterBody3D

var astar:AStar3D
var ID_target:int
var deviation:float = 1.0
var path:PackedVector3Array
@export var speed:int = 500
@export var damage:int = 1
@export var health:int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		queue_free()
	if global_position.distance_to(Vector3(0,0,0)) < 10:
		queue_free()
		get_parent_node_3d().get_parent_node_3d().life_loss(damage)
	var direction:Vector3 = Vector3(0,0,0)
	if global_position.distance_to(path[0]) < deviation:
		path.remove_at(0)
	direction = global_position.direction_to(path[0])
	velocity = direction * speed * delta
	move_and_slide()

func _get_path():
	var current_ID = astar.get_closest_point(global_position)
	path = astar.get_point_path(current_ID,ID_target)

func summon():
	astar = get_parent_node_3d().get_parent_node_3d().astar
	ID_target = astar.get_closest_point(Vector3(0,0,0))
	_get_path()
