extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var font = load("res://Assets/Fonts/MagicCircleFont1.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	pass # Replace with function body.

func _draw():
	var number_of_letter = 16.0
	var letter_rotation_increment = (PI*(2/number_of_letter))
	var letter_rotation = 0
	
	for value in range(number_of_letter):
		draw_set_transform(Vector2(0,0), letter_rotation_increment*value, Vector2(1,1))
		draw_char(font, Vector2(-7,-108), "m", "", Color.fuchsia)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
