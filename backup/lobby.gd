extends Node

func _ready():
	$button_host.connect("pressed", self, "_on_button_host_pressed")
	$button_join.connect("pressed", self, "_on_button_join_pressed")
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print("Player connected to server!")
	globals.other_player_id = id
	var game = preload("res://game.tscn").instance()
	get_tree().get_root().add_child(game)
	$button_join.hide()
	$button_host.hide()
	$address.hide()

func _on_button_host_pressed():
	print("Hosting network")
	var host = NetworkedMultiplayerENet.new()
	var res = host.create_server(27015, 2)
	if res != OK:
		print("Error creating server")
		return
	$button_join.hide()
	$button_host.disabled = true
	$address.hide()
	get_tree().set_network_peer(host)

func _on_button_join_pressed():
	print("Joining network")
	var host = NetworkedMultiplayerENet.new()
	host.create_client(str($address.text), 27015)
	get_tree().set_network_peer(host)
	$button_host.hide()
	$button_join.disabled = true
	$address.hide()