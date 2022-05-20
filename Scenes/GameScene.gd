extends Node2D

onready var tower_textures = get_node("/root/TowerTextures")

const CELL_SIZE = 16
const WAVE_TIME_BETWEEN = 30

var map_node: Node2D
var wave_information
var current_wave = 1

var building_mode = false
var build_valid = false
var build_location: Vector2
var build_location_last_check: Vector2
var building_type: String
var building_category: String
var building_size := 0

var current_selection: Node2D
var building_list := {} #dictionary mapping vector2 coords to building roots

var selection_info: Array
var selection_node := weakref(null)

var color_deny = Color(1,0,0,.5)
var color_okay = Color(0,1,0,.5)

#var tower = load("res://Scenes/BuildingTower.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get correct map and store it
	map_node = get_node("Map")

	#get wave info and generate the actual waves
	wave_information = map_node.get_wave_information()
	modify_wave_information()
	#bootleg gamestart
	start_wave()
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
		

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		if building_mode:
			cancel_build_mode()
		else:
			if current_selection != null:
				deselect()
			
	if event.is_action_released("ui_accept"):
		if building_mode:
			match building_category:
				"Building":
					try_build_building()
				"Accessory":
					add_accessory(get_building_from_cell(map_node.get_node("Collisions").world_to_map(get_global_mouse_position()-map_node.position)))
		else:
			select_building(map_node.get_node("Collisions").world_to_map(get_global_mouse_position()-map_node.position))

func _process(delta):
	if building_mode:
		var preview = map_node.get_node("BuildingPreview")
		#need custom preview position for accessories for them incase they have issues snapping to things they shouldnt be 
		#allowed to build on in wierd places (ie on barracks they hug the bottom right)
		match building_category:
			"Building":
				get_best_tilemap_tile()
				build_valid = verify_tile_positions_as_buildable(building_size, build_location, (build_location_last_check != build_location))
				build_location_last_check = build_location
				preview.set_global_position((build_location-Vector2(1,1))*CELL_SIZE+map_node.position)
			"Accessory":
				var hover_location = map_node.get_node("Collisions").world_to_map(get_global_mouse_position()-map_node.position)
				var snap = should_snap(hover_location)
				if(snap): #if it should snap then snap to said location
					var relevant_building = get_building_from_cell(hover_location)
					build_location = relevant_building.grid_location
					preview.set_global_position(relevant_building.position-Vector2(CELL_SIZE,CELL_SIZE))
					build_valid = is_accessory_valid(relevant_building)
				else:
					preview.set_global_position((build_location-Vector2(1,1))*CELL_SIZE+map_node.position)
					get_best_tilemap_tile()
					build_valid = false
		
		if(build_valid):
			preview.modulate = color_okay
		else:
			preview.modulate = color_deny
	else:
		if(selection_info.size() > 0 && !selection_node.get_ref()):
			display_selection()

func display_selection():
	var magical_circle = load("res://Scenes/MagicCirclePNG.tscn").instance()
	selection_node = weakref(magical_circle)
	#selection_info = [6, Color.deeppink, Vector2(.2,.2)]
	magical_circle.set_circle(selection_info[0])
	magical_circle.set_color(selection_info[1])
	magical_circle.set_scale(selection_info[2])
	$UI.add_child(magical_circle)
	magical_circle.activate()
	magical_circle.position = current_selection.position

func select_building(cell: Vector2):
	if current_selection != null:
		deselect()
	current_selection = get_building_from_cell(cell)
	if current_selection != null:
		current_selection.do_selection(true)
		selection_info = current_selection.get_selection_info()
		selection_info = [6, Color.deeppink, Vector2(.3,.3)]
		#have tower get an outline
		#_unit_overlay.draw(_walkable_cells)

func deselect():
	current_selection.do_selection(false)
	current_selection = null
	selection_info = []
	if(selection_node.get_ref()):
		selection_node.get_ref().hide()
		selection_node.get_ref().queue_free()
		#selection_node == null


func get_building_from_cell(cell: Vector2): #returns null if no building is present
	var cell_value = map_node.get_node("Buildings").get_cellv(cell)
	if cell_value != -1:
		while (cell_value != 21): #this is the value it will be if it is the bottom right corner
			if(cell_value % 3 != 0): #if not on bottom shift downwards
				cell += Vector2(0,1)
			if(cell_value % 7 != 0): #if not on rightside shift right
				cell += Vector2(1,0)
			cell_value = map_node.get_node("Buildings").get_cellv(cell)
	if not building_list.has(cell):
		return null
	return building_list[cell]
	

func cancel_build_mode():
	building_mode = false
	build_valid = false
	map_node.get_node("BuildingPreview").hide()
	#$UI/BuildingPreview.hide()

func initiate_build_mode(type: String):
	if building_mode:
		cancel_build_mode()
	building_mode = true
	building_type = type
	match type:
		"Tower":
			building_category = "Building"
			building_size = 2
		"Barracks":
			building_category = "Building"
			building_size = 3
		"Orb":
			building_category = "Accessory"
	setup_preview(building_type, building_category)


func setup_preview(type: String, category: String):
	var preview = map_node.get_node("BuildingPreview")
	preview.texture = load("res://Assets/"+category+"/"+category+type+".png")
	preview.show()

func try_build_building():
	if build_valid:
		var new_building = load("res://Scenes/"+building_category+"/"+building_category+building_type+".tscn").instance()
		
		new_building.position = build_location*CELL_SIZE
		if building_size%2 == 1:
			new_building.position += Vector2(CELL_SIZE/2,CELL_SIZE/2)
		map_node.get_node("Towers").add_child(new_building, true)
		var grid_location = make_unbuildable(building_size, build_location)
		building_list[grid_location] = new_building
		new_building.grid_location = grid_location
		cancel_build_mode()

func verify_tile_positions_as_buildable(size: int, pos: Vector2, check_collisions: bool):
	if(check_collisions):
		var collisions = map_node.get_node("Collisions")
		var positions = []
		for xVal in size:
			for yVal in size:
				positions.append(pos + Vector2((xVal-floor(size/2)),(yVal-floor(size/2))))
		for value in positions:
			var check = collisions.get_cellv(value)
			if (check == 0) || (check == 1) || (map_node.get_node("Buildings").get_cellv(value) != -1):
				return false
		if(map_node.see_if_path_is_viable(positions)):
			return true
		return false
	return build_valid

#causes the collision and building maps to reflect the new building, returns the lowest right tile it built on
func make_unbuildable(size: int, pos: Vector2) -> Vector2:
	#var collisions = map_node.get_node("Collisions")
	var building_map = map_node.get_node("Buildings")
	var map_pos
	var number_for_building_map = 1
	for xVal in size:
		for yVal in size:
			map_pos = (pos + Vector2((xVal-floor(size/2)),(yVal-floor(size/2))))
			#collisions.set_cellv(map_pos, 0)
			if size == 1:
				number_for_building_map = 13
			else:
				if (yVal == 0):
					number_for_building_map *= 2 #top
				else: if (yVal == (size-1)):
					number_for_building_map *= 3 #bottom
				if (xVal == 0):
					number_for_building_map *= 5 #left
				else: if (xVal == (size-1)):
					number_for_building_map *= 7 #right
			building_map.set_cellv(map_pos, number_for_building_map)
			number_for_building_map = 1
	#collisions.update_dirty_quadrants()
	building_map.update_dirty_quadrants()
	map_node.update_enemy_paths()
	return map_pos

#finds the best tile to use for even sized buildings
func get_best_tilemap_tile():
	#might need to be global position for map?
	var pos := (get_global_mouse_position() - map_node.position)
	var xVal := 0
	var yVal := 0
	if building_size % 2 == 0:
		xVal = pos.x
		yVal = pos.y
		xVal %= CELL_SIZE
		yVal %= CELL_SIZE
		if xVal < CELL_SIZE/2:
			xVal - CELL_SIZE
		if yVal < CELL_SIZE/2:
			yVal - CELL_SIZE
	build_location = map_node.get_node("Collisions").world_to_map((Vector2(xVal, yVal) + pos))

func should_snap(cell: Vector2) -> bool:
	var cell_value = map_node.get_node("Buildings").get_cellv(cell)
	if cell_value != -1:
		return true
	return false
#		while (cell_value != 21): #this is the value it will be if it is the bottom right corner
#			if(cell_value % 3 != 0): #if not on bottom shift downwards
#				cell += Vector2(0,1)
#			if(cell_value % 7 != 0): #if not on rightside shift right
#				cell += Vector2(1,0)
#			cell_value = map_node.get_node("Buildings").get_cellv(cell)
#		return cell
#	return Vector2(0,0)


# are these two accessory methods possibly useless? yes, but I have them just incase
func is_accessory_valid(relevant_building) -> bool:
	return relevant_building.check_accessory_valid(building_type)

func add_accessory(relevant_building):
	if build_valid:
		relevant_building.add_accessory(building_type)
		cancel_build_mode()

func modify_wave_information():
	
	pass

func start_wave():
	if(current_wave <= wave_information.size()):
		if(current_wave <= 1):
			$WaveTimerBetween.start(WAVE_TIME_BETWEEN)
		map_node.start_wave(current_wave, wave_information[current_wave])
		current_wave += 1



