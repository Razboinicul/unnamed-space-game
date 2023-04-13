extends Node

var open_dcpu_acievememnt = false
var player_x = 0
var player_y = 0
var ship_vars = {"ram1":12, "ram2":10}
var sv_keys = ship_vars.keys()
func _ready():
	print("Initialized")
	set_process(true)
	for key in sv_keys:
		print(key+" "+str(ship_vars[key]))

func _process(_delta):
	sv_keys = ship_vars.keys()
