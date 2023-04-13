extends Node2D


func _on_Button_pressed():
	get_tree().quit()

func _on_Button2_pressed():
	get_tree().change_scene_to_file("res://Singleplayer/levels/node_3d.tscn")


func _on_Button3_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
