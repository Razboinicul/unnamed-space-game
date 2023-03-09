extends Node2D


func _on_Button_pressed():
	get_tree().quit()

func _on_Button2_pressed():
	get_tree().change_scene("res://Singleplayer/environment/World.tscn")


func _on_Button3_pressed():
	get_tree().change_scene("res://scenes/lobby.tscn")
