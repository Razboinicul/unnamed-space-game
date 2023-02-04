extends Node2D
var command
var param1
var param2
var parameter1
var parameter2
var button
var output
var out_label
var result
var text

func _ready():
	output = ""
	out_label = get_node("BG/Output")
	command = get_node("BG/command")
	param1 = get_node("BG/param1")
	param2 = get_node("BG/param2")
	button = get_node("BG/Button")

func detect_command(cmd, param1, param2):
	if cmd == "help":
		output = """help - see commands
add - param1 + param2
substract - param1 - param2
multiply - param1 * param2
divide - param1 : param2
exit - exit the DCPU
"""
	elif cmd == "exit":
		get_tree().quit()
	elif cmd == "add":
		param1 = int(param1)
		param2 = int(param2)
		param1 += param2
		output = param1
	elif cmd == "substract":
		param1 = int(param1)
		param2 = int(param2)
		param1 -= param2
		output = param1
	elif cmd == "multiply":
		param1 = int(param1)
		param2 = int(param2)
		result = param1* param2
		output = result
	elif cmd == "divide":
		param1 = int(param1)
		param2 = int(param2)
		result = param1/ param2
		output = result
	else:
		output = cmd

func _on_Button_pressed():
	text = command.text
	parameter1 = param1.text
	parameter2 = param2.text
	if parameter1 == null and parameter2 == null:
		parameter1 = ""
		parameter2 = ""
		detect_command(text, parameter1, parameter2)
		print(output)
	elif parameter1 == null:
		parameter1 = ""
		detect_command(text, parameter1, parameter2)
		print(output)
	elif parameter2 == null:
		parameter2 = ""
		detect_command(text, parameter1, parameter2)
		print(output)
	detect_command(text, parameter1, parameter2)
	output = str(output)
	out_label.text = output
	print(output)
