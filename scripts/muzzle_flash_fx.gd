extends MeshInstance

func _ready():
	yield(get_tree().create_timer(0.025), "timeout")
	queue_free()
	pass