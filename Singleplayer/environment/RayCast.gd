extends RayCast

func _ready():
	set_process(true)

func _process(_delta):
	if is_colliding():
		var obj = get_collider()
		if Input.is_action_just_pressed("mouse_left") and obj.get_name() == "DCPU":
			print(obj.get_name())
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene("res://ShipComputer/ShipComputer.tscn")
		else:
			print(obj.get_name())
