extends Camera

var magnitude = 0
var timeleft = 0
var is_shaking = false

func _ready():
	pass

func _process(delta):
	pass

func shake(new_magnitude, lifetime):
	if magnitude > new_magnitude:
		return
	
	magnitude = new_magnitude
	timeleft = lifetime
	
	if is_shaking:
		return
	is_shaking = true
	
	while timeleft > 0:
		var offset = Vector3()
		offset.x = rand_range(-magnitude, magnitude)
		offset.y = rand_range(-magnitude, magnitude)
		rotation = offset
		
		timeleft -= get_process_delta_time()
		yield(get_tree(), "idle_frame")
	
	magnitude = 0
	is_shaking = false
	rotation = Vector3(0, 0, 0)
	
	pass