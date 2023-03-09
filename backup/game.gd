extends Node

func _ready():
	# First create ourself
	var this_player = preload("res://scenes/player/player.tscn").instance()
	this_player.set_name(str(get_tree().get_network_unique_id()))
	this_player.set_network_master(get_tree().get_network_unique_id())
	add_child(this_player)
	this_player.global_transform.origin = $spawn_points/point.global_transform.origin

	# Now create the other player
	var other_player = preload("res://scenes/player/player.tscn").instance()
	other_player.set_name(str(globals.other_player_id))
	other_player.set_network_master(globals.other_player_id)
	add_child(other_player)
	other_player.global_transform.origin = $spawn_points/point2.global_transform.origin