extends "res://Scenes/Enemies/baddie.gd"

const BASE_VELOCITY = Vector2(25, 0.0)
#func _physics_process(delta):
#	position += velocity * delta * speed
func _ready():
	velocity = BASE_VELOCITY
