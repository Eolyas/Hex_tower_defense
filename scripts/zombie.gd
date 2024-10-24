extends CharacterBody3D

var speed:float = 100.0
@onready var nav:NavigationAgent3D = $NavigationAgent3D
var distance_to_heart:float
var path:PackedVector3Array
@export var life = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	path = nav.get_current_navigation_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	distance_to_heart = 0
	for i in range(path.size()-1):
		distance_to_heart += path[i].distance_to(path[i+1])
	var direction:Vector3 = Vector3()
	nav.target_position = Vector3(0,0,0)
	nav.set_debug_enabled(true)
	var next_pos = nav.get_next_path_position()
	direction = (next_pos - global_position).normalized()
	look_at(next_pos)
	velocity = direction * speed * delta
	move_and_slide()


func _on_navigation_agent_3d_path_changed():
	path = nav.get_current_navigation_path()

func take_damage(damage):
	print("took damage")
	life -= damage
	if life <= 0:
		queue_free()
