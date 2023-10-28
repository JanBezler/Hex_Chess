extends Control
class_name Promotion

var chosen_figure := ""

func _on_knight_pressed():
	chosen_figure = "K"
	hide_panel()

func _on_bishop_pressed():
	chosen_figure = "B"
	hide_panel()

func _on_rook_pressed():
	chosen_figure = "R"
	hide_panel()

func _on_queen_pressed():
	chosen_figure = "Q"
	hide_panel()

func get_chosen_fugure() -> String:
	return chosen_figure

func hide_panel():
	hide()

