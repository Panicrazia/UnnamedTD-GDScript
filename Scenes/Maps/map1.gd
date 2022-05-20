extends Node2D


# Declare member variables here. Examples:
onready var tower_textures = get_node("/root/TowerTextures")

const CELL_SIZE = 16
const MAP_BOUNDS = Vector2(63, 37)
const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
const DIRECTIONS_REVERSE = [Vector2.DOWN, Vector2.UP, Vector2.RIGHT, Vector2.LEFT]

var spawn_locations = []	#could be turned into a dictionary to specify spawning info, probs will be needed later
var flow_field_path
var bottlenecks := [] #if a slot is 1 then building on a space with that slot as the distance locks the paths

var instance
var building

var baddie = load("res://Scenes/baddie.tscn")
#buildings should be in a dictionary linking their name to their path

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_spawn_locations_array()
	flow_field_path = generate_flood_fill_path([])
	pass # Replace with function body.

#func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			instance = baddie.instance()
#			instance.position = event.position
#			instance.velocity = Vector2(rand_range(25.0, 50.0), 0.0)
#			add_child(instance)


func _process(delta):
	pass

func start_wave(wave_number, wave_info):
	#[["type", amount, separation_time, health, armor, [list of effects they would have]]]
	for enemy_information in wave_info:
		var timer = preload("res://Scenes/WaveTimer.tscn").instance()
		timer.name = (wave_number as String) + enemy_information[0]
		add_child(timer, true)
		timer.countdown_var = enemy_information[1]
		timer.connect("timeout", self, "spawn_enemy", [enemy_information[0],enemy_information[3],enemy_information[4],enemy_information[5]])
		timer.start(enemy_information[2])

func spawn_enemy(type, health, armor, effects):
	var new_enemy = load("res://Scenes/Enemies/" + type + ".tscn").instance()
	new_enemy.set_spawn_info(health, armor, effects)
	#this will always be the same random in each game, Im not sure if I want to keep that or not
	var spawnloc = spawn_locations[randi() % spawn_locations.size()]
	$Enemies.add_child(new_enemy)
	new_enemy.position = spawnloc + Vector2(8,8)
	new_enemy.update_path(flow_field_path)

func populate_spawn_locations_array():
	for coordinates in $SpawnLocations.get_used_cells_by_id(0):
		spawn_locations.append(coordinates*CELL_SIZE)
	pass

func get_wave_information() -> Dictionary:
	return $WaveInformation.base_wave_information.duplicate(true)

func generate_flood_fill_path(test_locations: Array) -> Dictionary:
	#should only ever be one of these tiles
	var start = $SpawnLocations.get_used_cells_by_id(1)[0]
	var stack := [start]
	var came_from := {} #dictionary of vector2 to an array containing vector2 and distance
	var current
	var offset
	
	came_from[start] = [null, 0]
	#if(test_locations.empty()):
	$Pathing.clear()
	
	#apparently godot has issues with doing this recursively for whatever reason, if I knew more about threads it probs could be done that way though
	while not stack.empty():
		current = stack.pop_front()
		offset = start - current
		
		#I dont think a distance check is needed but heres some code incase it somehow becomes relevant
		#var difference: Vector2 = (current - cell).abs()
		#var distance := int(difference.x + difference.y)
		#if distance > max_distance:
		#	continue
		
		if ((offset.x as int + offset.y as int)%2):
			for direction in range(3,-1,-1):
				check_neighbors(direction, stack, came_from, current, test_locations)
		else:
			for direction in range(0,4,1):
				check_neighbors(direction, stack, came_from, current, test_locations)
	return came_from

func check_neighbors(direction: int, stack: Array, came_from: Dictionary, current: Vector2, test_locations: Array):
	var coordinates: Vector2 = current + (DIRECTIONS[direction])
	if coordinates in came_from:
		return
	if test_locations.has(coordinates):
		return
	if(($Collisions.get_cellv(coordinates) == -1) && ($Buildings.get_cellv(coordinates) == -1)):
		came_from[coordinates] = [current,(1 + came_from[current][1])]
		
		$Pathing.set_cell(coordinates.x, coordinates.y, direction)
		
		if not is_on_map_edge(coordinates):
			stack.append(coordinates)

func see_if_path_is_viable(test_locations: Array) -> bool:
	var checks = $SpawnLocations.get_used_cells_by_id(0)
	var feild = generate_flood_fill_path(test_locations)
	for value in checks:
		if(!feild.has(value)):
			return false
	return true

func is_on_map_edge(coords):
	if((coords.x < 0) or (coords.x > MAP_BOUNDS.x) or (coords.y < 0) or (coords.y > MAP_BOUNDS.y)):
		return true
	return false

func update_enemy_paths():
	flow_field_path = generate_flood_fill_path([])
	for enemy in $Enemies.get_children():
		enemy.update_path(flow_field_path)
