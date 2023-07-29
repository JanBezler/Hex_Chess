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

func _ready():
	draw_figures()
	
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
		
func move_figure(current: String, destination: String):
	var c_kv = Utils.to_kv(current)
	var d_kv = Utils.to_kv(destination)
	state_table[d_kv[1]][d_kv[0]] = state_table[c_kv[1]][c_kv[0]] 
	state_table[c_kv[1]][c_kv[0]]  = ""

func what_figure_at(field: String) -> String:
	var position := Utils.to_kv(field)
	return state_table[position[1]][position[0]]
	




