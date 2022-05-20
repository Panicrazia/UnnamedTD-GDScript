extends "res://Scenes/Building/BuildingBase.gd"

func check_accessory_valid(type: String) -> bool:
	if accessories.has(type):
		return false
	#later on the accessory array will probs have fixed locations for things (ie shooter [0], lens [1], etc)
	#checking if the building is valid is probs easier with a hardcoded enum or something like tower textures
	return true
