extends Node3D

@onready var player = get_node("Player")
@onready var label = get_node("Health")
func _ready():
	set_process(true)
	
func _process(_delta: float):
	if player.health == 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://death/Death.tscn")
	else:
		label.text = 'Health: %s' % player.health
