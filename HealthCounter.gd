extends Spatial

onready var player = get_node("Player")
onready var label = get_node("Health")
func _ready():
	set_process(true)
	
func _process(_delta: float):
	if player.health == 0:
		get_tree().quit()
	else:
		label.text = 'Health: %s' % player.health
