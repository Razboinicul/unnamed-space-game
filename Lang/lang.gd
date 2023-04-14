extends Control

# Define the memory and registers
var memory = []
var registers = {}
var console = []
var virtual_screen
var console_text
var timer = null
var can_run = true
var thread = null
# Define the program counter
var PC = 0

func rect(x, y, width, height):
	var rect = ColorRect.new()
	rect.color = Color.WHITE
	rect.position.x = x
	rect.position.y = y
	rect.size.x = width
	rect.size.y = height
	$Screen/Control.add_child(rect)
	
func del_rect(x, y, width, height):
	var rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.position.x = x
	rect.position.y = y
	rect.size.x = width
	rect.size.y = height
	$Screen/Control.add_child(rect)

func text(text, x, y):
	var rect = Label.new()
	rect.text = text
	rect.position.x = x
	rect.position.y = y
	$Screen/Control.add_child(rect)

func clear_screen():
	var clear = ColorRect.new()
	clear.color = Color.BLACK
	clear.size.x = 773
	clear.size.y = 505
	$Screen/Control.add_child(clear)
# Load a program into memory
func load_program(program):
	memory = program
	PC = 0

# Execute the current instruction
func execute_instruction():
	# Fetch the next command from memory
	var command = memory[PC]
	PC += 1
	
	# Decode the command and operands
	var parts = command.split(" ")
	var op = parts[0]
	var args = []
	if parts.size() > 1:
		for i in range(1, parts.size()):
			args.append(parts[i])

	# Execute the command
	if "#" in op:
		return
	if op == "END":
		return
	if op == "SET":
		var reg = args[0]
		var val = parse_value(args[1])
		registers[reg] = val
	elif op == "ADD":
		var reg = args[0]
		var val = parse_value(args[1])
		registers[reg] += val
	elif op == "SUB":
		var reg = args[0]
		var val = parse_value(args[1])
		registers[reg] -= val
	elif op == "MUL":
		var reg = args[0]
		var val = parse_value(args[1])
		registers[reg] *= val
	elif op == "DIV":
		var reg = args[0]
		var val = parse_value(args[1])
		registers[reg] /= val
	elif op == "PRINT":
		var string = ""
		for word in args:
			if word in registers:
				word = registers[word]
			string = string+" "+str(word)
		console.append(string)
	elif op == "DRAW_RECT":
		var x = parse_value(args[0])
		var y = parse_value(args[1])
		var width = parse_value(args[2])
		var height = parse_value(args[3])
		rect(x, y, width, height)
	elif op == "CLS":
		clear_screen()
	elif op == "IF":
		var reg = args[0]
		var _op = args[1]
		var val = parse_value(args[2])
		var jump = parse_value(args[3])
		if check_condition(reg, _op, val):
			PC += jump
	elif op == "DRAW_TEXT":
		var string = ""
		var x = parse_value(args[0])
		var y = parse_value(args[1])
		args.erase(args[0])
		args.erase(args[0])
		for word in args:
			string = string+" "+word
		print(string)
		text(string, x, y)
	elif op == "WHILE":
		var reg = args[0]
		var _op = args[1]
		var val = parse_value(args[2])
		var start_pc = PC
		while check_condition(reg, _op, val):
			# Execute the instructions inside the loop
			while memory[PC] != "END":
				execute_instruction()
			# Reset the program counter to the start of the loop
			PC = start_pc
	elif op == "WAIT":
		var seconds = parse_value(args[0])
		if timer == null:
			timer = await wait(seconds)
		timer = null
	else:
		print("Invalid command: " + command)

func wait(time):
	timer = Timer.new()
	timer.wait_time = time
	timer.timeout.connect(_wait_timeout)
	can_run = false
	add_child(timer)

func parse_value(value):
	if value in registers:
		return registers[value]
	else:
		return int(value)

# Check a condition
func check_condition(reg, op, val):
	if op == "==":
		return registers[reg] == val
	elif op == "!=":
		return registers[reg] != val
	elif op == "<":
		return registers[reg] < val
	elif op == ">":
		return registers[reg] > val
	elif op == "<=":
		return registers[reg] <= val
	elif op == ">=":
		return registers[reg] >= val
	else:
		return false

# Execute the program
func run():
	while PC < len(memory):
		if can_run:
			execute_instruction()
	can_run = false
	thread.wait_to_finish()
		
func reset():
	console_text = """"""
	can_run = true
	virtual_screen = get_node("Screen/Control")
	clear_screen()

# Example program
#var raw_program = """
#SET A 1
#SET B 2
#IF A == 1 2
#ADD A B
#IF A < 3 1
#SUB A 1
#IF A > 1 2
#MUL A B
#DIV A 3
#PRINT A
#PRINT B
#PRINT HELLO WORLD
#DRAW_RECT 0 0 20 20
#DRAW_TEXT 20 50 HELLO WORLD
#"""

var raw_program = """
#TEST PROGRAM
SET A 1
SET R_X 0
WHILE R_X <= 20
CLS
DRAW_RECT R_X 0 20 20
ADD R_X 1
PRINT R_X
WAIT 10
END
"""

var program = raw_program.split("\n", false)

func _ready():
	thread = Thread.new()
	var reset = reset()
	var load = load_program(program)
	thread.start(run)
	
func _process(delta):
	$Debug.text = "Registers: "+"\n"+str(registers)
	for output in console:
		console_text = str(console_text)+"\n"+str(output)
	$Console.text = console_text

func _wait_timeout():
	can_run = true
	timer.queue_free()
