extends Area

func _ready():
	connect("body_entered", self, "_on_body_entered")
	pass

func _on_body_entered(body):
	if body is KinematicBody and body.has_method("set_ammo_supply"):
		body.set_ammo_supply(body.ammo_supply + 32)
		if body.has_node("audio/ammo_up"):
			body.get_node("audio/ammo_up").play()
		get_parent().queue_free()