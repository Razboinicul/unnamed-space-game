extends Node2D
var LineEdit
var button
var output
var out_label
var text

func _ready():
	output = ""
	out_label = get_node("DcpuInputBg/Output")
	LineEdit = get_node("DcpuInputBg/LineEdit")
	button = get_node("DcpuInputBg/Button")

func detect_command(text):
	if text == "help":
		output = """help - see commands
exit - exit the DCPU
"""
	elif text == "exit":
		get_tree().quit()
	else:
		output = text

func _on_Button_pressed():
	text = LineEdit.text
	detect_command(text)
	out_label.text = output
	print(out_label.text)
