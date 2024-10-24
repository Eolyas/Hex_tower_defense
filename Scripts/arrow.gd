extends Node3D

var target
@export var speed = 3
@export var damage = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var direction = Vector3(0,0,0)
	direction = (global_position.direction_to(target.global_position)).normalized()
	global_position += direction * speed

func set_target(temp):
	target = temp


func _on_body_entered(body):
	if body.is_in_group("monster"):
		body.health -= damage
		queue_free()

func target_destroyed():
	queue_free()
