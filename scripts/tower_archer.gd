extends Node3D

@onready var radius:float = $range/CollisionShape3D.shape.radius
@export var attack_range:float = 3.5
@export var projectile:PackedScene
var mob_in_range:Array[CharacterBody3D]
var target:CharacterBody3D

func _ready():
	radius = attack_range

func _physics_process(_delta):
	pass

func choose_target():
	var temp:float = 0
	var temp_body:CharacterBody3D
	for body:CharacterBody3D in mob_in_range:
		var path:float = body.distance_to_heart
		if path > temp:
			temp = path
			temp_body = body
	target = temp_body

func _on_range_body_entered(body):
	if body.is_in_group("mob"):
		mob_in_range.append(body)
		choose_target()


func _on_range_body_exited(body):
	if body.is_in_group("mob"):
		mob_in_range.erase(body)
		choose_target()


func _on_cooldown_timeout():
	var arrow:Area3D = projectile.instantiate()
	add_child(arrow)
	arrow.global_position = $pivot/shooting_point.global_position
	arrow.set_target(target)
	print("arrow sent")
	
	
