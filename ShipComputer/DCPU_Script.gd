extends Node2D
var command
var param1
var param2
var var1
var var2
var parameter1
var parameter2
var button
var exit
var output
var out_label
var vars
var v_text
var result
var text
var ram1
var ram2
var ram3
var ram4
var last_res

func _ready():
	ram1 = 5
	ram2 = 15
	output = ""
	out_label = get_node("BG/Output")
	exit = get_node("BG/Exit")
	command = get_node("BG/command")
	param1 = get_node("BG/param1")
	param2 = get_node("BG/param2")
	vars = get_node("BG/vars")
	button = get_node("BG/Button")
	
func detect_vars(v1, v2):
	if v1 == "ram1" and v2 == "ram1":
		var1 = ram1
		var2 = ram1
	elif v1 == "ram2" and v2 == "ram2":
		var1 = ram2
		var2 = ram2
	elif v1 == "ram3" and v2 == "ram3":
		var1 = ram3
		var2 = ram3
	elif v1 == "ram4" and v2 == "ram4":
		var1 = ram4
		var2 = ram4
	elif v1 == "ram1" and v2 == "ram2":
		var1 = ram1
		var2 = ram2
	elif v1 == "ram1" and v2 == "ram3":
		var1 = ram1
		var2 = ram3
	elif v1 == "ram1" and v2 == "ram4":
		var1 = ram1
		var2 = ram4
	elif v1 == "ram2" and v2 == "ram1":
		var1 = ram2
		var2 = ram1
	elif v1 == "ram2" and v2 == "ram3":
		var1 = ram2
		var2 = ram3
	elif v1 == "ram2" and v2 == "ram4":
		var1 = ram2
		var2 = ram4
	elif v1 == "ram3" and v2 == "ram1":
		var1 = ram3
		var2 = ram1
	elif v1 == "ram3" and v2 == "ram2":
		var1 = ram3
		var2 = ram2
	elif v1 == "ram3" and v2 == "ram4":
		var1 = ram3
		var2 = ram4
	elif v1 == "ram4" and v2 == "ram1":
		var1 = ram4
		var2 = ram1
	elif v1 == "ram4" and v2 == "ram2":
		var1 = ram3
		var2 = ram2
	elif v1 == "ram4" and v2 == "ram3":
		var1 = ram3
		var2 = ram3
	elif v1 == "ram1":
		var1 = ram1
	elif v2 == "ram1":
		var2 = ram1
	elif v1 == "ram2":
		var1 = ram2
	elif v2 == "ram2":
		var2 = ram2
	elif v1 == "ram3":
		var1 = ram3
	elif v2 == "ram3":
		var2 = ram3
	elif v1 == "ram4":
		var1 = ram4
	elif v2 == "ram4":
		var2 = ram4
	else:
		pass
		
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
		if v_text == "vars":
			detect_vars(param1, param2)
			var1 = int(var1)
			var2 = int(var2)
			result = var1 + var2
			output = result
		else:
			param1 = int(param1)
			param2 = int(param2)
			param1 += param2
			output = param1
	elif cmd == "substract":
		if v_text == "vars":
			detect_vars(param1, param2)
			var1 = int(var1)
			var2 = int(var2)
			result = var1 - var2
			output = result
		else:
			param1 = int(param1)
			param2 = int(param2)
			param1 -= param2
			output = param1
	elif cmd == "multiply":
		if v_text == "vars":
			detect_vars(param1, param2)
			var1 = int(var1)
			var2 = int(var2)
			result = var1 * var2
			output = result
		else:
			param1 = int(param1)
			param2 = int(param2)
			param1 += param2
			result = param1* param2
			output = result
	elif cmd == "divide":
		if v_text == "vars":
			detect_vars(param1, param2)
			var1 = int(var1)
			var2 = int(var2)
			result = var1 / var2
			output = result
		else:
			param1 = int(param1)
			param2 = int(param2)
			param1 += param2
			result = param1 / param2
			output = result
	elif cmd == "store":
		if param1 == "ram1":
			if v_text == "vars":
				detect_vars(param1, param2)
				ram1 = var2
			else:
				ram1 = param2
		elif param1 == "ram2":
			if v_text == "vars":
				detect_vars(param1, param2)
				ram2 = var2
			else:
				ram2 = param2
		elif param1 == "ram3":
			if v_text == "vars":
				detect_vars(param1, param2)
				ram3 = var2
			else:
				ram3 = param2
		elif param1 == "ram4":
			if v_text == "vars":
				detect_vars(param1, param2)
				ram4 = var2
			else:
				ram4 = param2
	else:
		output = "Error 1"

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
	v_text = vars.text
	detect_command(text, parameter1, parameter2)
	output = str(output)
	out_label.text = output
	print(output)


func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	get_tree().change_scene("environment/World.tscn")
