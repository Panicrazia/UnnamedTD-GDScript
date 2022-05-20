extends Node2D


var home_point: Vector2
var speed := 45.0
var damage = 100
var effects = []

var enemy_array = []
var current_target = null
var in_combat := false
var combat_range: int
var engage_range: int
var attack_cooldown := 120
var current_attack_cooldown := 0
#shot timers and range areas should probably be added via code to make new accessories not a massive pain inthe balls

func _ready():
	combat_range = $HitBox/HitboxRange.shape.radius
	engage_range = $EnemyDecection/EngageRange.shape.radius + 20
	pass

func _physics_process(delta):
	if(in_combat && current_target):
		if(!current_target.get_ref()): #if enemy is dead
			in_combat = false
			select_target()
		else:
			if(move_towards_target(delta)):
				if(current_attack_cooldown <= 0):
					attack_target()
				
	else:
		if(!enemy_array.empty()):
			select_target()
		if(global_position.distance_squared_to(home_point) > 1):
			look_at(home_point)
			position += Vector2.RIGHT.rotated(rotation) * delta * speed
	$Sprite.rotation = -rotation
	current_attack_cooldown -= 1

func attack_target():
	current_attack_cooldown = attack_cooldown
	var actual_target = current_target.get_ref().get_parent()
	actual_target.damage(damage)
	actual_target.doEffects(effects)

func move_towards_target(delta) -> bool: #returns true if already in range
	var target_position = current_target.get_ref().get_global_transform().origin
	var is_within_range = (combat_range*combat_range) > (target_position - get_global_transform().origin).length_squared()
	if(!is_within_range):
		look_at(target_position)
		position += Vector2.RIGHT.rotated(rotation) * delta * speed
	return is_within_range

func _on_EnemyDecection_area_entered(area):
	if area.is_in_group("baddies"):
		enemy_array.append(area)

func _on_EnemyDecection_area_exited(area):
	if area.is_in_group("baddies"):
		enemy_array.erase(area)
		if (current_target && current_target.get_ref() && area == current_target.get_ref()):
			current_target = null
			select_target()

func select_target():
	#friendly units should probably only target closest (with exceptions for certain units)
	if enemy_array.size() > 0:
		for enemy in enemy_array:
			var target_position = enemy.get_global_transform().origin
			var is_within_range = (engage_range*engage_range) > (target_position.distance_squared_to(home_point))
			if is_within_range:
				current_target = weakref(enemy)
				break
#	for target in enemy_array:
#		#currently a very scuffed targetting system
#		current_target = weakref(target)
	if current_target:
		in_combat = true

func get_target():
	return current_target
