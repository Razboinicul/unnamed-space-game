extends Spatial

func _ready():
	yield(get_tree().create_timer(15), "timeout")
	queue_free()
	pass