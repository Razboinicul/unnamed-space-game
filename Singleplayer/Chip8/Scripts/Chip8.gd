extends ColorRect

export (Color, RGB) var backgroundColor	= Color("#000000")
export (Color, RGB) var accentColor		= Color("#ffdd34")

export (bool) var autoPixelScale = false
export (int) var pixelScale = 10

export (String) var startRomPath = "res://Chip8/Roms/TETRIS.c8"

var system = {
	memory = [],	# Memory of 4K (4096 address)
	registers = [],	# 16 Registers (V0, V1, ..., VE)
	opcode = 0,
	index = 0,
	pc = 0,
	gfx = [],		# Graphics display of (64 * 32)
	delayTimer = 0,
	soundTimer = 0,
	stack = [],		# 16 levels
	sp = 0,
	keys = [],		# 16 buttons on keyboard
	fontSet = [
		0xF0, 0x90, 0x90, 0x90, 0xF0, # 0
		0x20, 0x60, 0x20, 0x20, 0x70, # 1
		0xF0, 0x10, 0xF0, 0x80, 0xF0, # 2
		0xF0, 0x10, 0xF0, 0x10, 0xF0, # 3
		0x90, 0x90, 0xF0, 0x10, 0x10, # 4
		0xF0, 0x80, 0xF0, 0x10, 0xF0, # 5
		0xF0, 0x80, 0xF0, 0x90, 0xF0, # 6
		0xF0, 0x10, 0x20, 0x40, 0x40, # 7
		0xF0, 0x90, 0xF0, 0x90, 0xF0, # 8
		0xF0, 0x90, 0xF0, 0x10, 0xF0, # 9
		0xF0, 0x90, 0xF0, 0x90, 0x90, # A
		0xE0, 0x90, 0xE0, 0x90, 0xE0, # B
		0xF0, 0x80, 0x80, 0x80, 0xF0, # C
		0xE0, 0x90, 0x90, 0x90, 0xE0, # D
		0xF0, 0x80, 0xF0, 0x80, 0xF0, # E
		0xF0, 0x80, 0xF0, 0x80, 0x80  # F
	],
	needsRedraw = true,
	canRun = false
}

var systemSpecs = {
	memorySize = 4096,
	numRegisters = 16,
	displaySize = (64 * 32),
	stackLevels = 16,
	keyboardButtons = 16
}

func initChip8():
	# Initialize all memory and it's sizes
	system.memory = []
	for i in range(systemSpecs.memorySize):
		system.memory.append(0)
	
	system.registers = []
	for i in range(systemSpecs.numRegisters):
		system.registers.append(0)
	
	system.gfx = []
	for i in range(systemSpecs.displaySize):
		system.gfx.append(0)
	
	system.stack = []
	for i in range(systemSpecs.stackLevels):
		system.stack.append(0)
	
	system.keys = []
	for i in range(systemSpecs.keyboardButtons):
		system.keys.append(0)
	
	system.opcode = 0
	system.pc = 0x200
	system.index = 0
	system.sp = 0
	
	system.delayTimer = 0
	system.soundTimer = 0
	
	system.needsRedraw = true
	
	for i in range(system.fontSet.size()):
		system.memory[0x50 + i] = system.fontSet[i] & 0xFF

func runChip8():
	var jumpInstruction = false
	
	system.opcode = (system.memory[system.pc] << 8) | system.memory[system.pc + 1]
	
	#print("Executing opcode: %X" % (system.opcode))
	#print("Current pc: %X" % system.pc)
	
	match (system.opcode & 0xF000):
		0x0000:
			match (system.opcode & 0x0FFF):
				0x00E0: # Instruction: CLS
					for i in range(system.gfx.size()):
						system.gfx[i] = 0
					
					system.needsRedraw = true
				0x00EE: # Instruction: RET
					system.sp -= 1
					system.pc = system.stack[system.sp] + 2
					
					jumpInstruction = true
				_: # Instruction: SYS addr
					var addr = system.opcode & 0x0FFF
					
					system.pc = addr
					
					jumpInstruction = true
		0x1000: # Instruction: JP addr
			var addr = system.opcode & 0x0FFF
			
			system.pc = addr
			
			jumpInstruction = true
		0x2000: # Instruction: CALL addr
			var addr = system.opcode & 0x0FFF
			
			system.stack[system.sp] = system.pc
			system.sp += 1
			
			system.pc = addr
			
			jumpInstruction = true
		0x3000: # Instruction: SE Vx, byte
			var vx		= (system.opcode & 0x0F00) >> 8
			var byte	= (system.opcode & 0x00FF)
			
			if (system.registers[vx] == byte):
				system.pc += 2
		0x4000: # Instruction: SNE Vx, byte
			var vx		= (system.opcode & 0x0F00) >> 8
			var byte	= (system.opcode & 0x00FF)
			
			if (system.registers[vx] != byte):
				system.pc += 2
		0x5000: # Instruction: SE Vx, Vy
			var vx = (system.opcode & 0x0F00) >> 8
			var vy = (system.opcode & 0x00F0) >> 4
			
			if (system.registers[vx] == system.registers[vy]):
				system.pc += 2
		0x6000: # Instruction: LD Vx, byte
			var vx		= (system.opcode & 0x0F00) >> 8
			var byte	= (system.opcode & 0x00FF)
			
			system.registers[vx] = byte
		0x7000: # Instruction: ADD Vx, byte
			var vx		= (system.opcode & 0x0F00) >> 8
			var byte	= (system.opcode & 0x00FF)
			
			system.registers[vx] = (system.registers[vx] + byte) & 0xFF
		0x8000:
			match (system.opcode & 0x000F):
				0x0000: # Instruction: LD Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					system.registers[vx] = system.registers[vy]
				0x0001: # Instruction: OR Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					system.registers[vx] = (system.registers[vx] | system.registers[vy]) & 0xFF
				0x0002: # Instruction: AND Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					system.registers[vx] = system.registers[vx] & system.registers[vy]
				0x0003: # Instruction: XOR Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					system.registers[vx] = (system.registers[vx] ^ system.registers[vy]) & 0xFF
				0x0004: # Instruction: ADD Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					var result = system.registers[vx] + system.registers[vy]
					
					if (result > 255):
						system.registers[0xF] = 1
					
					system.registers[vx] = result & 0xFF
				0x0005: # Instruction: SUB Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					var result = system.registers[vx] - system.registers[vy]
					
					if (system.registers[vx] > system.registers[vy]):
						system.registers[0xF] = 1
					else:
						system.registers[0xF] = 0
					
					system.registers[vx] = result & 0xFF
				0x0006: # Instruction: SHR Vx {, Vy}
					var vx = (system.opcode & 0x0F00) >> 8
					
					var result = system.registers[vx] & 0x1
					
					if (result == 1):
						system.registers[0xF] = 1
					else:
						system.registers[0xF] = 0
					
					system.registers[vx] = system.registers[vx] >> 1
				0x0007: # Instruction: SUBN Vx, Vy
					var vx = (system.opcode & 0x0F00) >> 8
					var vy = (system.opcode & 0x00F0) >> 4
					
					var result = system.registers[vy] - system.registers[vx]
					
					if (system.registers[vy] > system.registers[vx]):
						system.registers[0xF] = 1
					else:
						system.registers[0xF] = 0
					
					system.registers[vx] = result & 0xFF
				0x000E: # Instruction: SHL Vx {, Vy}
					var vx = (system.opcode & 0x0F00) >> 8
					
					var result = system.registers[vx] & 0x80
					
					if (result == 1):
						system.registers[0xF] = 1
					else:
						system.registers[0xF] = 0
					
					system.registers[vx] = system.registers[vx] << 1
				_:
					print("Unsupported opcoded [0x8000]: %X" % system.opcode)
		0x9000: # Instruction: SNE Vx, Vy
			var vx = (system.opcode & 0x0F00) >> 8
			var vy = (system.opcode & 0x00F0) >> 4
			
			if (system.registers[vx] != system.registers[vy]):
				system.pc += 2
		0xA000: # Instruction: LD I, addr
			var addr = system.opcode & 0x0FFF
			
			system.index = addr
		0xB000: # Instruction: JP V0, addr
			var addr = system.opcode & 0x0FFF
			
			system.pc = addr + (system.registers[0x0] & 0xFF)
			
			jumpInstruction = true
		0xC000: # Instruction: RND Vx, byte
			var vx		= (system.opcode & 0x0F00) >> 8
			var byte	= (system.opcode & 0x00FF)
			
			var result = (randi() % 256) & byte
			
			system.registers[vx] = result
		0xD000: # Instruction: DRW Vx, Vy, nibble
			var vx		= (system.opcode & 0x0F00) >> 8
			var vy		= (system.opcode & 0x00F0) >> 4
			var nibble	= (system.opcode & 0x000F)
			
			var xPosition = system.registers[vx]
			var yPosition = system.registers[vy]
			
			system.registers[0xF] = 0
			
			for yLine in range(nibble):
				var line = system.memory[system.index + yLine]
				
				for xLine in range(8):
					var pixel = line & (0x80 >> xLine)
					
					if (pixel != 0):
						var totalX = (xPosition + xLine) % 64
						var totalY = (yPosition + yLine) % 32
						var index = (totalY * 64) + totalX
						
						if (system.gfx[index] == 1):
							system.registers[0xF] = 1
						
						system.gfx[index] = system.gfx[index] ^ 1
			#
			system.needsRedraw = true
		0xE000:
			match (system.opcode & 0x00FF):
				0x009E: # Instruction: SKP Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					if (system.keys[system.registers[vx]] == 1):
						system.pc += 2
				0x00A1: # Instruction: SKNP Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					if (system.keys[system.registers[vx]] != 1):
						system.pc += 2
				_:
					print("Unsupported opcoded [0xE000]: %X" % system.opcode)
		0xF000:
			match (system.opcode & 0x00FF):
				0x0007: # Instruction: LD Vx, DT
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.registers[vx] = system.delayTimer
				0x000A: # Instruction: LD Vx, K
					var vx = (system.opcode & 0x0F00) >> 8
					
					jumpInstruction = true
					
					for i in range(system.keys.size()):
						if (system.keys[i] == 1):
							jumpInstruction = false
							system.registers[vx] = i
							
							break
				0x0015: # Instruction: LD DT, Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.delayTimer = system.registers[vx]
				0x0018: # Instruction: LD ST, Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.soundTimer = system.registers[vx]
				0x001E: # Instruction: ADD I, Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.index += system.registers[vx]
				0x0029: # Instruction: LD F, Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.index = 0x50 + (system.registers[vx] * 5)
				0x0033: # Instruction: LD B, Vx
					var vx = (system.opcode & 0x0F00) >> 8
					
					system.memory[system.index] = int(system.registers[vx] / 100)
					system.memory[system.index + 1] = int(system.registers[vx] / 10) % 10
					system.memory[system.index + 2] = int(system.registers[vx] % 100) % 100
				0x0055: # Instruction: LD [I], Vx
					var start = (system.opcode & 0x0F00) >> 8
					
					for i in range(start):
						system.memory[system.index + i] = system.registers[i]
				0x0065: # Instruction: LD Vx, [I]
					var start = (system.opcode & 0x0F00) >> 8
					
					for i in range(start):
						system.registers[i] = system.memory[system.index + i]
					
					system.index = system.index + start + 1
				_:
					print("Unsupported opcoded [0xF000]: %X" % system.opcode)
		_:
			print("Unsupported opcoded: %X" % system.opcode)
	
	if (jumpInstruction == false):
		system.pc += 2
	
	if (system.delayTimer > 0):
		system.delayTimer -= 1
	
	if (system.soundTimer > 0):
		if (system.soundTimer == 1):
			$AudioStreamPlayer.play()
		system.soundTimer -= 1

func loadRomFromFile(romPath):
	var file = File.new()
	
	if (file.file_exists(romPath)):
		initChip8()
		file.open(romPath, File.READ)
		
		var offset = 0
		
		while (!file.eof_reached()):
			system.memory[0x200 + offset] = file.get_8()
			
			offset += 1
		
		system.canRun = true
		
		file.close()
		print("Loaded rom from path: ", romPath)
	else:
		print("Rom " + romPath + " not found")

func _ready():
	loadRomFromFile(startRomPath)

func _process(delta):
	if (system.canRun):
		if (system.needsRedraw):
			system.needsRedraw = false
			update()
		
		runChip8()

func _input(event):
	if (event is InputEventKey):
		if (event.pressed):
			for i in range(16):
				var key = ("%X" % i)
				
				if (event.is_action("chip8_key_" + key)):
					system.keys[i] = 1
		else:
			for i in range(system.keys.size()):
				system.keys[i] = 0

func _draw():
	for i in range(system.gfx.size()):
		var x		= i % 64
		var y		= int(i / 64)
		var color	= backgroundColor
		
		if (system.gfx[i] == 1):
			color = accentColor
		
		draw_rect(Rect2(x * pixelScale, y * pixelScale, pixelScale, pixelScale), color)


func _on_Display_item_rect_changed():
	if (autoPixelScale):
		pixelScale = rect_size.x / 64
		
		if (system.canRun):
			system.needsRedraw = true
