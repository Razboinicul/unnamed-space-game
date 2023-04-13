extends RayCast3D

func _ready():
	add_exception(get_owner())

func _process(delta):
	if is_colliding():
		var obj = get_collider()
		if Input.is_action_just_pressed("mouse_right") and obj.get_name() == "test":
			print(obj.get_name())
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			print(obj.get_name())
