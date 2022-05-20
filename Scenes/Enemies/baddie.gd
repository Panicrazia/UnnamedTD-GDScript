extends Node2D

const CELL_SIZE = 16
#health and whatnot should be changed to consts to have the base health/armor/whatnot
var health = 10
var armor = 0
var speed = 25
var effects := []
var velocity = Vector2.ZERO
var path: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func damage(damageDone):
	damageDone -= armor
	if damageDone > 0:
		health -= damageDone
		if health < 0 :
			queue_free()

func doEffects(effects: Array):
	#print("baddie got hit by a projectle")
	pass

func _physics_process(delta):
	#probs should have a thing where the goal location is updated when the path changes or they enter a new tile, to avoid many maths
	if(position):
#		var adjusted_position = position + get_parent().get_parent().position
#		var goal = path[Vector2(floor(adjusted_position.x/16 as int), floor(adjusted_position.y/16 as int))]
#		look_at(Vector2((goal.x*16),(goal.y*16)))
		var position_adjustment = get_parent().get_parent().position
		var goal = path[Vector2(floor(position.x/16 as int), floor(position.y/16 as int))][0]
		look_at(Vector2((goal.x*16)+8+position_adjustment.x,(goal.y*16)+8+position_adjustment.y))
		position += Vector2.RIGHT.rotated(rotation) * delta * speed


func set_spawn_info(new_health, new_armor, effects: Array):
	health = new_health
	armor = new_armor
	#apply effects

func update_path(new_path: Dictionary):
	path = new_path
