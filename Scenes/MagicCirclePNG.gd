extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var circle := "res://Assets/Magical Circles/Circle6.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Projectiles.modulate = Color.red
	#$PNGSprite.modulate = Color(1,0,1,1)
	#$PNGSprite.texture = load(circle)
	#activate()
	pass

func _process(delta):
	rotation += .005
	pass

func activate():
	visible = true

func set_scale(new_scale):
	scale = new_scale
	
func set_circle(circle_id: int):
	circle = "res://Assets/Magical Circles/Circle" + (circle_id as String) + ".png"

func set_color(new_color):
	$PNGSprite.modulate = new_color
