extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#MAKE SURE ALL THE POINTS OF ROTATION AND SIZE BOUNDS GET SET CORRECTLY HERE
	
	$TextureRect.rect_position = $TextureRect.rect_size/-2
	$TextureRect/TextDrawer.position = $TextureRect.rect_size/2
	#scale = Vector2(.5,.5)
	$Control.rect_global_position = Vector2(-1000,-1000)
	#modulate.a = .7
#	yield(VisualServer, "frame_post_draw")
#	$Control.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureRect.rect_rotation += .3
	#rotation += .003
	#$Control.rect_rotation = -rotation
	pass
