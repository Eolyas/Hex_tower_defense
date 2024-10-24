extends CharacterBody3D

@export var speed:float = 100.0

func _physics_process(_delta):
	var direction:Vector3 = Vector3(0,0,0)
	if Input.is_action_pressed("right"):
		direction += Vector3(1,0,0)
	if Input.is_action_pressed("left"):
		direction += Vector3(-1,0,0)
	if Input.is_action_pressed("top"):
		direction += Vector3(0,0,-1)
	if Input.is_action_pressed("bottom"):
		direction += Vector3(0,0,1)
	direction.normalized()
	velocity = speed * direction
	move_and_slide()
