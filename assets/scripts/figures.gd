extends Node2D

var board: Board 
var line_texture := preload("res://assets/textures/center_linear_gradient.tres")
var default_figure_fields = {
	"PW1":"BW1", "PW2":"CW2", "PW3":"D3", "PW4":"E4", "PW5":"F5", "PW6":"G5", "PW7":"H5", "PW8":"I5", "PW9":"J5",
	"BW1":"F1", "BW2":"F2", "BW3":"F3", "KW1":"D1", "KW2":"H3", "RW1":"C1", "RW2":"I4", "QW1":"E1", "GW1":"G2",
	"PB1":"BB7", "PB2":"CB7", "PB3":"D7", "PB4":"E7", "PB5":"F7", "PB6":"G8", "PB7":"H9", "PB8":"I10", "PB9":"J11",
	"BB1":"F11", "BB2":"F10", "BB3":"F9", "KB1":"D9", "KB2":"H11", "RB1":"C8", "RB2":"I11", "QB1":"E10", "GB1":"G11"
}

func _ready():
	board = $"../Board"
	
	for fig in default_figure_fields:
		var figure_node = getFigureSprite(fig)
		figure_node.position = board.getFieldPosition(default_figure_fields[fig])
		add_child(figure_node)
		
	create_border(100, board.getFieldPosition("h5"))
	create_border(100, board.getFieldPosition("h6"))
	create_border(100, board.getFieldPosition("h7"))


func getFigureSprite(name: String) -> Sprite2D:
	var frame_num := 0
	
	if name[0] == "P":
		frame_num = 5
	elif name[0] == "R":
		frame_num = 4
	elif name[0] == "K":
		frame_num = 3
	elif name[0] == "B":
		frame_num = 2
	elif name[0] == "Q":
		frame_num = 1
	elif name[0] == "G":
		frame_num = 0
	
	if name[1] == "B":
		frame_num += 6
		
	var new_sprite := $"../Figure".duplicate()
	new_sprite.frame = frame_num
	new_sprite.visible = true
	return new_sprite

func create_border(radius:float, coords:Vector2):
	var height = radius*sqrt(3)/2
	var line = Line2D.new()
	var points := []
	line.add_point(Vector2(-radius/2, height))
	line.add_point(Vector2(radius/2, height))
	line.add_point(Vector2(radius, 0))
	line.add_point(Vector2(radius/2, -height))
	line.add_point(Vector2(-radius/2, -height))
	line.add_point(Vector2(-radius, 0))
	line.add_point(Vector2(-radius/2, height))
	line.translate(coords)
	line.default_color = Color.PALE_GREEN
	line.width = 12
	line.texture = line_texture
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.antialiased = true
	add_child(line)
	
