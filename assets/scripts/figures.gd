extends Node2D
class_name Figures

@export var board: Board
@export var default_marker_color: Color #fefb327f
@export var check_marker_color: Color 
@export var line_texture: Texture2D
@export var figure_sprite: Texture2D

var figure_sprites_parent := Node2D.new()
var marker_sprites_parent := Node2D.new()

func draw_figures(state_table: Array):
	var new_sprites_parent := Node2D.new()

	var row_num := 1
	for row in state_table:
		for key in row:
			var fig = row[key]
			if fig != "":
				var sprite = get_figure_sprite(fig)
				sprite.position = board.get_field_position(key, row_num)
				new_sprites_parent.add_child(sprite)
		row_num += 1
		
	figure_sprites_parent.queue_free()
	add_child(new_sprites_parent)
	figure_sprites_parent = new_sprites_parent
	
func draw_markers(fields: Array):
	var new_sprites_parent := Node2D.new()
	for field in fields:
		var marker = create_marker(70)
		marker.translate(board.get_field_position(field))
		new_sprites_parent.add_child(marker)
		
	marker_sprites_parent.queue_free()
	add_child(new_sprites_parent)
	marker_sprites_parent = new_sprites_parent

func get_figure_sprite(fig_name: String) -> Sprite2D:
	var frame_num := 0
	
	if fig_name[1].to_upper() == "P":
		frame_num = 5
	elif fig_name[1].to_upper() == "R":
		frame_num = 4
	elif fig_name[1].to_upper() == "K":
		frame_num = 3
	elif fig_name[1].to_upper() == "B":
		frame_num = 2
	elif fig_name[1].to_upper() == "Q":
		frame_num = 1
	elif fig_name[1].to_upper() == "G":
		frame_num = 0
	
	if Utils.is_black(fig_name):
		frame_num += 6
		
	var sprite := Sprite2D.new()
	sprite.texture = figure_sprite
	sprite.hframes = 6
	sprite.vframes = 2
	sprite.frame = frame_num
	return sprite

func create_marker(radius: float, color: Color = Color.BLACK) -> Line2D:
	var height = radius*sqrt(3)/2
	var line = Line2D.new()
	line.add_point(Vector2(0, height))
	line.add_point(Vector2(radius/2, height))
	line.add_point(Vector2(radius, 0))
	line.add_point(Vector2(radius/2, -height))
	line.add_point(Vector2(-radius/2, -height))
	line.add_point(Vector2(-radius, 0))
	line.add_point(Vector2(-radius/2, height))
	line.add_point(Vector2(0, height))
	line.width = 20
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.antialiased = true
	if color == Color.BLACK:
		line.default_color = default_marker_color
	else:
		line.default_color = color
	return line
