class_name Utils

static var all_fields := ["A1","B1","C1","D1","E1","F1","A2","B2","C2","D2",
"E2","F2","G2","A3","B3","C3","D3","E3","F3","G3","H3","A4","B4","C4","D4",
"E4","F4","G4","H4","I4","A5","B5","C5","D5","E5","F5","G5","H5","I5","J5",
"A6","B6","C6","D6","E6","F6","G6","H6","I6","J6","K6","B7","C7","D7","E7",
"F7","G7","H7","I7","J7","K7","C8","D8","E8","F8","G8","H8","I8","J8","K8",
"D9","E9","F9","G9","H9","I9","J9","K9","E10","F10","G10","H10","I10","J10",
"K10","F11","G11","H11","I11","J11","K11"]

static func to_kv(string: String, num: int = 0) -> Array:
	if len(string) == 1 and num in range(1,12):	
		return [string.capitalize(), num-1]
	elif len(string) in range(2,4) and num == 0:
		return [string[0].capitalize(), int(string.right(len(string)-1))-1]
	return []

static func to_str(chr: String, num: int = 0) -> String:
	if len(chr) == 1 and num in range(1,12):	
		return chr.capitalize() + str(num)
	elif len(chr) in range(2,4) and num == 0:
		return chr
	return ""

static func is_black(figName: String) -> bool:
	return figName[0].to_lower() == "b"

static func is_pawn(figName: String) -> bool:
	return figName[1].to_upper() == "P"

static func is_knight(figName: String) -> bool:
	return figName[1].to_upper() == "K"

static func is_bishop(figName: String) -> bool:
	return figName[1].to_upper() == "B"

static func is_rook(figName: String) -> bool:
	return figName[1].to_upper() == "R"

static func is_queen(figName: String) -> bool:
	return figName[1].to_upper() == "Q"

static func is_king(figName: String) -> bool:
	return figName[1].to_upper() == "G"

static func field_exist(field: String) -> bool:
	return field in all_fields

static func return_existing(field: String) -> String:
	if field_exist(field):
		return field
	return ""


static func char_up(chr: String) -> String:
	return String.chr(chr.unicode_at(0) + 1)
	
static func char_down(chr: String) -> String:
	return String.chr(chr.unicode_at(0) - 1)


static func field_up(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(kv[0] + str(kv[1] + 2))
	
static func field_up_right(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_up(kv[0]) + str(kv[1] + 2))
	
static func field_up_left(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_down(kv[0]) + str(kv[1] + 1))
	
static func field_down(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(kv[0] + str(kv[1]))
	
static func field_down_right(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_up(kv[0]) + str(kv[1] + 1))
	
static func field_down_left(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_down(kv[0]) + str(kv[1]))
	

static func field_diag_right(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_up(char_up(kv[0])) + str(kv[1] + 2))
	
static func field_diag_up_right(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_up(kv[0]) + str(kv[1] + 3))
	
static func field_diag_up_left(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_down(kv[0]) + str(kv[1] + 2))
	
static func field_diag_left(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_down(char_down(kv[0])) + str(kv[1]))
	
static func field_diag_down_right(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_up(kv[0]) + str(kv[1]))
	
static func field_diag_down_left(field: String) -> String:
	var kv := to_kv(field)
	return return_existing(char_down(kv[0]) + str(kv[1] - 1))

static func deep_copy(object):
	if object is Array:
		return deep_copy_array(object)
	elif object is Dictionary:
		return deep_copy_dict(object)
	else:
		return object.duplicate()

static func deep_copy_array(arr):
	var copied_arr = []
	
	for item in arr:
		if item is Array:
			copied_arr.append(deep_copy_array(item))
		elif item is Dictionary:
			copied_arr.append(deep_copy_dict(item))
		else:
			copied_arr.append(item)
	
	return copied_arr
	
static func deep_copy_dict(dict):
	var copied_dict = {}

	for key in dict.keys():
		var value = dict[key]
		if value is Array:
			copied_dict[key] = deep_copy_array(value)
		elif value is Dictionary:
			copied_dict[key] = deep_copy_dict(value)
		else:
			copied_dict[key] = value

	return copied_dict
