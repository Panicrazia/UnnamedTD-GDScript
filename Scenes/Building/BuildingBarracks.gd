extends "res://Scenes/Building/BuildingBase.gd"

var rally_point: Vector2
var soldiers := []
var soldierType
var max_soldiers: int
var deploy_spread: float #how far units will be from the center of the rally point
var deploy_speed := 1.0

func _ready():
	deploy_spread = 25.0
	$SoldierSpawnTimer.wait_time = deploy_speed
	$SoldierSpawnTimer.start()
	max_soldiers = 3
	soldierType = load("res://Scenes/Units/Friendly/Soldier.tscn")

func check_accessory_valid(type: String) -> bool:
	if accessories.has(type):
		return false
	#later on the accessory array will probs have fixed locations for things (ie shooter [0], lens [1], etc)
	#checking if the building is valid is probs easier with a hardcoded enum or something like tower textures
	return false

func do_selection(is_being_selected: bool):
	.do_selection(is_being_selected) #this is how you super

func move_rally_point(new_point: Vector2):
	rally_point = new_point
	
#determines a vector2 point around the rally point for a given soldier, where soldier is its slot in the array
func get_point_arround_rally(soldier_array_pos: int) -> Vector2: 
	if(max_soldiers == 1):
		return rally_point
	var point := Vector2(0,-deploy_spread)
	var degrees_separation = (PI*2)/max_soldiers
	point = rally_point + point.rotated(degrees_separation*soldier_array_pos)
	return point
	
func spawn_soldier():
	var soldier_ammount = len(soldiers)
	if soldier_ammount < max_soldiers:
		var soldier = soldierType.instance()
		$Soldiers.add_child(soldier)
		soldier.position = $SpawnPoint.position
		soldier.home_point = get_point_arround_rally(soldier_ammount)
		soldiers.append(soldier)
		if (soldier_ammount+1) == max_soldiers:
			$SoldierSpawnTimer.stop()

func _on_SoldierSpawnTimer_timeout():
	rally_point = get_global_position()
	spawn_soldier()
	pass # Replace with function body.

func on_soldier_killed(soldier):
	$SoldierSpawnTimer.start(deploy_speed)
	#and also remove from array
