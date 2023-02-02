extends Node2D
var LineEdit
var button
var output
var text

func _ready():
	LineEdit = get_node("DcpuInputBg/LineEdit")
	button = get_node("DcpuInputBg/Button")

func detect_command(text):
	if text == "help":
		output = """help - see commands
exit - exit the DCPU
"""
	elif text == "exit":
		get_tree().quit()

func _on_Button_pressed():
	text = LineEdit.text
	detect_command(text)
	print(output)
