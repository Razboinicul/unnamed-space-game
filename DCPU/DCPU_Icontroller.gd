extends Node2D
var text_label

const controller0 = preload("controller.gd") # Relative path
onready var controller = controller.new()

func _ready():
	text_label = get_node("ColorRect/Label")
	text_label.text = controller.output
