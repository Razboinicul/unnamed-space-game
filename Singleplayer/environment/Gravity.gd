extends Label

var GRAVITY

func _ready():
	set_process(true)
	
func _process(delta):
	GRAVITY = globals.gravity
	self.text = 'Gravity: %s' % GRAVITY
