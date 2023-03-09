extends Node

func _ready():
	$button.connect("pressed", self, "_on_pressed")
	pass
	
func _on_pressed():
	OS.set_window_size(Vector2($width.text, $height.text))
	OS.window_fullscreen = $fullscreen.pressed
	pass