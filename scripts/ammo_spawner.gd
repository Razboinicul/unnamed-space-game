extends Position3D

var ammo_near = false
onready var scn_ammo = preload("res://scenes/ammo.tscn")
onready var regex = RegEx.new()	

func _ready():
	regex.compile("ammo")
	$timer.connect("timeout", self, "_on_timeout")
	$area.connect("body_entered", self, "_on_body_entered")
	$area.connect("body_exited", self, "_on_body_exited")
	spawn()
	pass

func _process(delta):
	pass
	
func spawn():
	if !ammo_near:
		var ammo = scn_ammo.instance()
		ammo.global_transform.origin = global_transform.origin
		get_tree().root.add_child(ammo)
		$spawn.play()
	$timer.start()
	
func _on_timeout():
	spawn()
	pass

func _on_body_entered(body):
	if body is RigidBody:
		var result = regex.search(str(body.name))
		if result:
			#print(result.get_string())
			ammo_near = true
	pass

func _on_body_exited(body):
	if body is RigidBody:
		var result = regex.search(str(body.name))
		if result:
			ammo_near = false
	pass
