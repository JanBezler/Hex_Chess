extends Node2D
class_name Figures

var line_texture := preload("res://assets/textures/center_linear_gradient.tres")
var figure_sprite := preload("res://assets/images/figures.png")

func _ready():
	pass

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

func create_border(radius: float, coords: Vector2) -> Line2D:
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
	line.translate(coords)
	line.default_color = Color(0.996078, 0.984314, 0.196078, 0.5)
	line.width = 20
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.antialiased = true
	return line
