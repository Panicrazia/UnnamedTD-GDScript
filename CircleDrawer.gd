extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var font = load("res://Assets/Fonts/MagicCircleFont1.tres")
var transparent_color = Color(0,0,0,0.0)
var antiallias = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = (get_parent().size)/2
	update()


func _draw():
	
	var bounds = 300.0
	var center = Vector2(0,0)#Vector2((bounds/2),(bounds/2))
	#draw_rect(Rect2(Vector2(-size,-size), Vector2(size*2,size*2)),Color.chartreuse,true, 1,antiallias)
	draw_arc(center, 50.0, 0, 2*PI, 24, Color.fuchsia, 2, antiallias)
	draw_arc(center, 126.0, 0, 2*PI, 60, Color.fuchsia, 4, antiallias)
	#draw_arc(center, 130.0, 0, 2*PI, 60, Color.blue, 4, antiallias)
	#draw_arc(Vector2(0,0), 154.0, 0, 2*PI, 60, Color(0.0,0.0,0.0,0.0), 4, true)
	#draw_char(font, Vector2(-15,-100), "A", "", Color.fuchsia)
	
	#draw_set_transform(center, letter_rotation_increment*value, Vector2(1,1))
	draw_arc(center + Vector2(0,-116), 10, 0, 2*PI, 60, Color.fuchsia, 3, antiallias)
	draw_set_transform(center, PI*1.3 ,Vector2(1,1))
	#draw_set_transform(Vector2(0,0), letter_rotation_increment, Vector2(1,1))
	draw_arc(center + Vector2(0,-106), 20, 0, 2*PI, 60, Color.fuchsia, 3, antiallias)
#	for value in range(number_of_letter):
#		draw_set_transform(Vector2(0,0), letter_rotation_increment*value, Vector2(1,1))
#		draw_char(font, Vector2(-15,-110), "A", "", Color.fuchsia)
#
#	for value in range(number_of_letter):
#		draw_set_transform(center, letter_rotation_increment*value, Vector2(1,1))
#		draw_char(font, Vector2(-6,-108), "m", "", Color.fuchsia)
	
	
	#rotation = PI/6
#	draw_set_transform(Vector2(0,0), PI/6, Vector2(1,1))
#	draw_char(font, Vector2(-15,-100), "B", "", Color.fuchsia)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	#rotation += .005
	pass
