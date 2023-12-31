extends Node2D
class_name Board

@export var background: ColorRect
@export var tile_map: TileMap
@export var color_white: Color
@export var color_black: Color

var board := [
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0)},
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0)},
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0)},
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0)},
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0)},
	{"A":Vector2(0,0),"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
	{"B":Vector2(0,0),"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
	{"C":Vector2(0,0),"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
	{"D":Vector2(0,0),"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
	{"E":Vector2(0,0),"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
	{"F":Vector2(0,0),"G":Vector2(0,0),"H":Vector2(0,0),"I":Vector2(0,0),"J":Vector2(0,0),"K":Vector2(0,0)},
]

var side: float
var height: float

func _ready():
	side = tile_map.tile_set.tile_size[0] / 2.0
	height = side * sqrt(3) / 2.0
	create_map()

func create_map():
	var translation__vector := Vector2(self.side * 7.5, -height * 5)
	var columns_x := {}
	var counter := 0
	for charCode in "ABCDEFGHIJK":
		columns_x[charCode] = counter * self.side * 1.5
		counter += 1

	var y := 0.0
	for num in range(len(board)):
		y = height * 2 * -num
		if num > 5:
			y += height  * (num - 5)
		for chr in board[num].keys():
			board[num][chr] = Vector2(columns_x[chr], y) - translation__vector
			y += height

func get_field_position(chr: String, num: int = 0) -> Vector2:
	var kv = Utils.to_kv(chr, num)
	return board[kv[1]][kv[0]]

func which_field_clicked(coords: Vector2) -> String:
	for row in len(board):
		for col in board[row]:
			if coords.distance_to(board[row][col]) < height:
				return col+str(row+1)
	return ""

func set_background_color(to_black: bool):
	if to_black:
		background.color = color_black
	else:
		background.color = color_white
	
				
	


			
		
			



	

