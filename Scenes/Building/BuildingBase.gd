extends Node2D


var accessories := []

var grid_location #the location this is saved to in the GameScene
var is_selected = false

func add_accessory(type: String):
	var accessory = load("res://Scenes/Accessory/Accessory"+ type +".tscn").instance()
	accessories.append(type)
	$Accessories.add_child(accessory)

func check_accessory_valid(type: String) -> bool:
	if accessories.has(type):
		return false
	#later on the accessory array will probs have fixed locations for things (ie shooter [0], lens [1], etc)
	#checking if the building is valid is probs easier with a hardcoded enum or something like tower textures
	return true

func _ready():
	pass

func do_selection(is_being_selected: bool):
	is_selected = is_being_selected
	update()
	for value in $Accessories.get_children():
		value.flag_selection(is_being_selected)

func get_selection_info() -> Array:
	
	return []
