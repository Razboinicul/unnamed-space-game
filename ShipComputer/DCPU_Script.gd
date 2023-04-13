extends Control
@onready var command
@onready var param1
@onready var param2
@onready var var1
@onready var var2
@onready var parameter1
@onready var parameter2
@onready var button
@onready var exit
@onready var output
@onready var out_label
@onready var vars
@onready var v_text
@onready var result
@onready var text

func _ready():
	output = ""
	out_label = get_node("BG/Output")
	exit = get_node("BG/Exit")
	command = get_node("BG/command")
	param1 = get_node("BG/param1")
	param2 = get_node("BG/param2")
	vars = get_node("BG/vars")
	button = get_node("BG/Button")
	
func detect_vars(v1, v2):
	for key in Global.sv_keys:
		if v1 == key:
			var1 = Global.ship_vars[key]
		if v2 == key:
			var2 = Global.ship_vars[key]
		
func detect_command(cmd, param1, param2):
	if cmd == "exit":
		get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
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
			result = param1 + param2
			output = result
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
			result = param1 - param2
			output = result
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
			result = param1 / param2
			output = result
	elif cmd == "store":
		pass
	else:
		output = "Error 1"

func _on_Button_pressed():
	text = command.text
	parameter1 = param1.text
	parameter2 = param2.text
	if parameter1 == null:
		parameter1 = ""
	if parameter2 == null:
		parameter2 = ""
	v_text = vars.text
	detect_command(text, parameter1, parameter2)
	output = str(output)
	out_label.text = output
	print(output)


func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()
	get_tree().change_scene_to_file("res://Singleplayer/environment/World.tscn")
