extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var color_deny = Color(1,0,0,.5)
var color_okay = Color(0,1,0,.5)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#building preveiws will need to change back to just sprites so you can build while paused
#func set_building_preview(type, pos):
#	var drag_tower = load("res://Scenes/Building" + type + ".tscn").instance()
#	drag_tower.name = "DragTower"
#	drag_tower.modulate = color_deny
#
#	var control = Control.new()
#	control.add_child(drag_tower, true)
#	control.rect_position = pos
#	control.name = "BuildingPreview"
#	add_child(control, true)
#	move_child(get_node("BuildingPreview"), 0)
#
#func update_building_preview(pos, color):
#	get_node("BuildingPreview").rect_position = pos
#	if (get_node("BuildingPreview/DragTower").modulate != color):
#		get_node("BuildingPreview/DragTower").modulate = color
#	pass

