extends Node
class_name GameState

@export var board: Board
@export var figures: Figures

var state_table := [
	{"A":"","B":"wP","C":"wR","D":"wK","E":"wQ","F":"wB"}, #1
	{"A":"","B":"","C":"wP","D":"","E":"","F":"wB","G":"wG"}, #2
	{"A":"","B":"","C":"","D":"wP","E":"","F":"wB","G":"","H":"wK"}, #3
	{"A":"","B":"","C":"","D":"","E":"wP","F":"","G":"","H":"","I":"wR"}, #4
	{"A":"","B":"","C":"","D":"","E":"","F":"wP","G":"wP","H":"wP","I":"wP","J":"wP"}, #5
	{"A":"","B":"","C":"","D":"","E":"","F":"","G":"","H":"","I":"","J":"","K":""}, #6
	{"B":"bP","C":"bP","D":"bP","E":"bP","F":"bP","G":"","H":"","I":"","J":"","K":""}, #7
	{"C":"bR","D":"","E":"","F":"","G":"bP","H":"","I":"","J":"","K":""}, #8
	{"D":"bK","E":"","F":"bB","G":"","H":"bP","I":"","J":"","K":""}, #9
	{"E":"bQ","F":"bB","G":"","H":"","I":"bP","J":"","K":""}, #10
	{"F":"bB","G":"bG","H":"bK","I":"bR","J":"bP","K":""} #11
]

var checked_field := ""
var showed_markers := []
var is_black_turn := false
var enemy_possible_moves := []

func _ready():
	figures.draw_figures(state_table)
	board.set_background_color(false)

func _process(_delta):
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_position := get_viewport().get_camera_2d().get_global_mouse_position()
		var field_clicked = board.which_field_clicked(mouse_position)
		var figure_clicked = what_figure_at(field_clicked)
		var is_figure_clicked = figure_clicked != ""

		if field_clicked in showed_markers:
			move_figure(checked_field, field_clicked)
			next_turn()
				
		elif is_figure_clicked and (is_black_turn == Utils.is_black(figure_clicked)):
			showed_markers = get_possible_moves(field_clicked)
			figures.draw_markers(showed_markers)
			checked_field = field_clicked


func next_turn():
	if is_black_turn:
		is_black_turn = false
	else:
		is_black_turn = true
		
	board.set_background_color(is_black_turn)
	figures.draw_markers([])
	figures.draw_figures(state_table)
	checked_field = ""
	showed_markers = []
	enemy_possible_moves = all_possible_moves(!is_black_turn)
	if is_in_check():
		if is_in_checkmate():
			if is_in_stealmate():
				print("STEALMATE!")
			else:
				print("CHECKMATE!")
		else:
			print("CHECK!")
	
		

func get_possible_moves(from_field: String, only_attack:bool = false) -> Array:
	var figure := what_figure_at(from_field)
	if !from_field.is_empty() and !figure.is_empty():
		if Utils.is_pawn(figure):
			if only_attack:
				return pawn_possible_attack_moves(from_field)
			return pawn_possible_moves(from_field)
		elif Utils.is_rook(figure):
			return rook_possible_moves(from_field)
		elif Utils.is_bishop(figure):
			return bishop_possible_moves(from_field)
		elif Utils.is_knight(figure):
			return knight_possible_moves(from_field)
		elif Utils.is_queen(figure):
			return queen_possible_moves(from_field)
		elif Utils.is_king(figure):
			return king_possible_moves(from_field)
	return []
		
func move_figure(current: String, destination: String):
	var c_kv = Utils.to_kv(current)
	var d_kv = Utils.to_kv(destination)
	state_table[d_kv[1]][d_kv[0]] = state_table[c_kv[1]][c_kv[0]] 
	state_table[c_kv[1]][c_kv[0]] = ""

func what_figure_at(field: String) -> String:
	if field.is_empty():
		return ""
	var position := Utils.to_kv(field)
	return state_table[position[1]][position[0]]

func is_ally_at(str_pos: String, str_dest: String) -> bool:
	var fig1 = what_figure_at(str_pos)
	var fig2 = what_figure_at(str_dest)
	if !fig2.is_empty():
		if Utils.is_black(fig1) == Utils.is_black(fig2):
			return true
	return false

func is_enemy_at(str_pos: String, str_dest: String) -> bool:
	var fig1 = what_figure_at(str_pos)
	var fig2 = what_figure_at(str_dest)
	if !fig2.is_empty():
		if Utils.is_black(fig1) != Utils.is_black(fig2):
			return true
	return false

func is_in_check(speific_enemy_possible_moves: Array = []) -> bool:
	if speific_enemy_possible_moves.is_empty():
		speific_enemy_possible_moves = enemy_possible_moves
	for field in speific_enemy_possible_moves:
		var figure = what_figure_at(field)
		if figure != "" and Utils.is_king(figure) and Utils.is_black(figure) == is_black_turn:
			return true
	return false
	
func is_in_checkmate() -> bool:
	var state_table_before = Utils.deep_copy(state_table)
	for fig_field in Utils.all_fields:
		var figure = what_figure_at(fig_field)
		if figure != "" and (Utils.is_black(figure) == is_black_turn):
			for possible_field in get_possible_moves(fig_field):
				move_figure(fig_field, possible_field)
				var is_chceckmate := is_in_check()
				if !is_chceckmate:
					if Utils.is_king(figure) and Utils.is_black(figure) == is_black_turn:
						is_chceckmate = is_in_check(all_possible_moves(!is_black_turn))
				state_table = Utils.deep_copy(state_table_before)
				if not is_chceckmate:	
					return false
	state_table = Utils.deep_copy(state_table_before)
	return true
	
func is_in_stealmate() -> bool:
	return false


# MOVES CHECKING

func pawn_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	var starting_white := ["B1", "C2", "D3", "E4", "F5", "G5", "H5", "I5", "J5"]
	var starting_black := ["B7", "C7", "D7", "E7", "F7", "G8", "H9", "I10", "J11"]
	var is_black := Utils.is_black(what_figure_at(str_pos))
	
	if is_black:
		var next = Utils.field_down(str_pos)
		if what_figure_at(next).is_empty():
			possible_fields.append(next)
			if str_pos in starting_black:
				next = Utils.field_down(next)
				if what_figure_at(next).is_empty():
					possible_fields.append(next)

	else:
		var next = Utils.field_up(str_pos)
		if what_figure_at(next).is_empty():
			possible_fields.append(next)
			if  str_pos in starting_white:
				next = Utils.field_up(next)
				if what_figure_at(next).is_empty():
					possible_fields.append(next)
	
	possible_fields.append_array(pawn_possible_attack_moves(str_pos))
	return possible_fields
	
func pawn_possible_attack_moves(str_pos: String) -> Array:
	var possible_fields := []
	var is_black := Utils.is_black(what_figure_at(str_pos))
	
	if is_black:
		var next = Utils.field_down_right(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_down_left(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)

	else:
		var next = Utils.field_up_right(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_up_left(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)

	return possible_fields

func knight_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_diag_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up_right(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_right(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_down_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_down(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_right(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_down_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_down(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_left(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up_left(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_left(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_up_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_up_left(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_up_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_up_right(next)
		if !temp.is_empty() and !is_ally_at(str_pos, temp):
			possible_fields.append(temp)

	return possible_fields
		
func rook_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_up(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up(next)
	next = Utils.field_up_right(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up_right(next)
	next = Utils.field_down_right(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down_right(next)
	next = Utils.field_down(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down(next)
	next = Utils.field_down_left(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down_left(next)
	next = Utils.field_up_left(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up_left(next)

	return possible_fields
	
func bishop_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_diag_right(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_right(next)
	next = Utils.field_diag_up_right(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_up_right(next)
	next = Utils.field_diag_down_right(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_down_right(next)
	next = Utils.field_diag_left(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_left(next)
	next = Utils.field_diag_down_left(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_down_left(next)
	next = Utils.field_diag_up_left(str_pos)
	while !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_up_left(next)

	return possible_fields
	
func queen_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	possible_fields.append_array(bishop_possible_moves(str_pos))
	possible_fields.append_array(rook_possible_moves(str_pos))

	return possible_fields
	
func king_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_up(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_up_right(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down_right(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down_left(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_up_left(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_right(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_up_right(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_down_right(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_left(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_down_left(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_up_left(str_pos)
	if !next.is_empty() and !is_ally_at(str_pos, next):
		possible_fields.append(next)
	
	var real_possible_fields := []
	for possible_field in possible_fields:
		if possible_field not in enemy_possible_moves:
			real_possible_fields.append(possible_field)

	return real_possible_fields

func all_possible_moves(for_black: bool) -> Array:
	var possible_fields := []
	for field in Utils.all_fields:
		var figure = what_figure_at(field)
		if figure != "" and (Utils.is_black(figure) == for_black):
			possible_fields.append_array(get_possible_moves(field, true))
			
	return possible_fields
			

