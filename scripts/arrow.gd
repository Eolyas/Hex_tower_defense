extends Area3D

var target:CharacterBody3D
var total_length:float
@export var speed:float = 2.0
@export var damage:float = 5.0


func _physics_process(_delta):
	if target:
		print("move toward target")
		var direction = (target.global_position - global_position).normalized()
		translate(direction*speed)

func set_target(body:CharacterBody3D):
	target = body

func _on_body_entered(body):
	print("body entered")
	if body.is_in_group("mob"):
		print("mob damaged")
		body.take_damage(damage)
		queue_free()
