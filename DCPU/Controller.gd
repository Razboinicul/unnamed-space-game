extends Node2D
var LineEdit
var button
var text

func _ready():
	LineEdit = get_node("DcpuInputBg/LineEdit")
	button = get_node("DcpuInputBg/Button")

func _on_Button_pressed():
	text = LineEdit.text
	print(text)
