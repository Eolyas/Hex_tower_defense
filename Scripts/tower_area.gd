extends Node3D

@export var size:float = 1.0
var list_monster:Array = []
var radius:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = $Area3D/CollisionShape3D.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if list_monster.size() != 0:
		for body in list_monster:
			effects(body)

func effects(body):
	if body.current_effects.has(self):
		pass
	else:
		body.current_effects.append(self)
		body.speed *= 0.9

func _on_area_3d_body_entered(body):
	if not list_monster.has(body):
		list_monster.append(body)


func _on_area_3d_body_exited(body):
	if body.current_effects.has(self):
		body.current_effects.erase(self)
	list_monster.erase(body)
