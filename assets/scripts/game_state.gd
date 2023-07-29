extends Node
class_name GameState

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

var figure_sprites_parent := Node2D.new()
var marker_sprites_parent := Node2D.new()
var checked_field := ""
var showed_markers := []

func _ready():
	draw_figures()

func _process(_delta):
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_position := get_viewport().get_camera_2d().get_global_mouse_position()
		var field_clicked =  $"../Board".which_field_clicked(mouse_position)
		if field_clicked in showed_markers:
			print("in")
			move_figure(checked_field, field_clicked)
			draw_markers([])
			draw_figures()
			checked_field = ""
			showed_markers = []
		else:
			show_possible_moves(field_clicked)
			checked_field = field_clicked
			

func draw_figures():
	var new_sprites_parent := Node2D.new()

	var row_num := 1
	for row in state_table:
		for key in row:
			var fig = row[key]
			if fig != "":
				var sprite = $"../Figures".get_figure_sprite(fig)
				sprite.position = $"../Board".get_field_position(key, row_num)
				new_sprites_parent.add_child(sprite)
		row_num += 1
		
	figure_sprites_parent.queue_free()
	add_child(new_sprites_parent)
	figure_sprites_parent = new_sprites_parent
	
func draw_markers(coords: Array):
	var new_sprites_parent := Node2D.new()
	for xy in coords:
		new_sprites_parent.add_child($"../Figures".create_border(70, xy))
		
	marker_sprites_parent.queue_free()
	add_child(new_sprites_parent)
	marker_sprites_parent = new_sprites_parent
	
func show_possible_moves(from_field: String):
	var coords_array := []
	var figure := what_figure_at(from_field)
	if !from_field.is_empty() and !figure.is_empty():
		if figure[1] == "P":
			showed_markers = pawn_possible_moves(from_field)
		elif figure[1] == "R":
			showed_markers = rook_possible_moves(from_field)
		elif figure[1] == "B":
			showed_markers = bishop_possible_moves(from_field)
		elif figure[1] == "K":
			showed_markers = knight_possible_moves(from_field)
		elif figure[1] == "Q":
			showed_markers = queen_possible_moves(from_field)
		elif figure[1] == "G":
			showed_markers = king_possible_moves(from_field)
			
	for marker in showed_markers:
		coords_array.append($"../Board".get_field_position(marker))

	draw_markers(coords_array)
		
func move_figure(current: String, destination: String):
	var c_kv = Utils.to_kv(current)
	var d_kv = Utils.to_kv(destination)
	state_table[d_kv[1]][d_kv[0]] = state_table[c_kv[1]][c_kv[0]] 
	state_table[c_kv[1]][c_kv[0]]  = ""

func what_figure_at(field: String) -> String:
	if field.is_empty():
		return ""
	var position := Utils.to_kv(field)
	return state_table[position[1]][position[0]]
	
func can_move_to(str_pos: String, str_dest: String) -> bool:
	var fig1 = what_figure_at(str_pos)
	var fig2 = what_figure_at(str_dest)
	if !fig2.is_empty():
		if Utils.is_black(fig1) and Utils.is_black(fig2):
			return false
		elif !Utils.is_black(fig1) and !Utils.is_black(fig2):
			return false
	return true
	
func is_enemy_at(str_pos: String, str_dest: String) -> bool:
	var fig1 = what_figure_at(str_pos)
	var fig2 = what_figure_at(str_dest)
	if !fig2.is_empty():
		if Utils.is_black(fig1) and !Utils.is_black(fig2):
			return true
		elif !Utils.is_black(fig1) and Utils.is_black(fig2):
			return true
	return false
	
	
func pawn_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	var starting_white := ["B1", "C2", "D3", "E4", "F5", "G5", "H5", "I5", "J5"]
	var starting_black := ["B7", "C7", "D7", "E7", "F7", "G8", "H9", "I10", "J11"]
	var is_black := Utils.is_black(what_figure_at(str_pos))
	
	if is_black:
		var next = Utils.field_down_right(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_down_left(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_down(str_pos)
		if what_figure_at(next).is_empty():
			possible_fields.append(next)
			if str_pos in starting_black:
				next = Utils.field_down(next)
				if what_figure_at(next).is_empty():
					possible_fields.append(next)

	else:
		var next = Utils.field_up_right(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_up_left(str_pos)
		if !next.is_empty() and is_enemy_at(str_pos, next):
			possible_fields.append(next)
		next = Utils.field_up(str_pos)
		if what_figure_at(next).is_empty():
			possible_fields.append(next)
			if  str_pos in starting_white:
				next = Utils.field_up(next)
				if what_figure_at(next).is_empty():
					possible_fields.append(next)

	return possible_fields

func knight_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_diag_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up_right(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_right(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_down_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_down(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_right(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_down_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_down(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_left(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up_left(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_down_left(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_up_left(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_up_left(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	next = Utils.field_diag_up_right(str_pos)
	if !next.is_empty():
		var temp = Utils.field_up(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
		temp = Utils.field_up_right(next)
		if !temp.is_empty() and can_move_to(str_pos, temp):
			possible_fields.append(temp)
	
		
	return possible_fields
		
func rook_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_up(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up(next)
	next = Utils.field_up_right(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up_right(next)
	next = Utils.field_down_right(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down_right(next)
	next = Utils.field_down(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down(next)
	next = Utils.field_down_left(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_down_left(next)
	next = Utils.field_up_left(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_up_left(next)
		
	return possible_fields
	
func bishop_possible_moves(str_pos: String) -> Array:
	var possible_fields := []
	
	var next = Utils.field_diag_right(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_right(next)
	next = Utils.field_diag_up_right(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_up_right(next)
	next = Utils.field_diag_down_right(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_down_right(next)
	next = Utils.field_diag_left(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_left(next)
	next = Utils.field_diag_down_left(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		if is_enemy_at(str_pos, next):
			break
		next = Utils.field_diag_down_left(next)
	next = Utils.field_diag_up_left(str_pos)
	while !next.is_empty() and can_move_to(str_pos, next):
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
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_up_right(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down_right(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_down_left(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_up_left(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_right(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_up_right(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_down_right(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_left(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_down_left(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
	next = Utils.field_diag_up_left(str_pos)
	if !next.is_empty() and can_move_to(str_pos, next):
		possible_fields.append(next)
		
	return possible_fields

