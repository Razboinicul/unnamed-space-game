extends ColorRect

func create_score(player_name, score):
	var p_score = load("res://scenes/Player_score.tscn")
	var score_instance = p_score.instance()
	#get_node("name").text = player_name
	#get_node("score").text = score
	add_child(score_instance)
	
func change_score(new_score):
	get_node("score").text = new_score
