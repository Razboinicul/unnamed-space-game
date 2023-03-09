extends CPUParticles

func _ready():
	pass

func _process(delta):
	if !emitting:
		queue_free()
	pass