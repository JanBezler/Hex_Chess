extends Control
class_name CheckmateScene

func set_winner(black_won: bool):
	if black_won:
		$PanelContainer/VBoxContainer/Label2.text = "Black player wins!"
	else:
		$PanelContainer/VBoxContainer/Label2.text = "White player wins!"

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/main_scene.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
