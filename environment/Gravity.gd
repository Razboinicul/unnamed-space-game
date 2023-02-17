extends Label

onready var player = get_node("Player")
onready var GRAVITY = player.GRAVITY * 100

func _ready():
	set_process(true)
	
func _process(delta):
	GRAVITY = player.GRAVITY * 100
	self.text = 'Gravity: %s' % GRAVITY
