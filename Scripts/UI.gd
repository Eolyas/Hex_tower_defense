extends Control

func _ready():
	pass

func _process(_delta):
	$fps_counter.set_text("FPS " + str(Engine.get_frames_per_second()))
