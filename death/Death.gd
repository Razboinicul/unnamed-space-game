extends Node2D

func _on_Retry_pressed():
	get_tree().change_scene("res://environment/World.tscn")

func _on_Exit_pressed():
	get_tree().quit()


func _on_title_screen_pressed():
	get_tree().change_scene("res://title_screen/title_screen.tscn")
