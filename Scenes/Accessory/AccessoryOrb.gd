extends Node2D


var enemy_array = []
var current_target = null
var instance
var attack_range = 150
var attack_speed = 0
var shot = load("res://Scenes/projectile.tscn")
var selected = false
var instablility = 200
#shot timers and range areas should probably be added via code to make new accessories not a massive pain inthe balls

func _ready():
	var shape = CircleShape2D.new()
	shape.set_radius(attack_range)
	$Range/CollisionShape2D.shape = shape
	$ShotTimer.start() #this timer might need to be replaced with something else due to how it doenst work for very small values (waittime < .05 sec)
	$ShotTimer.set_paused(true)
	$Projectiles.modulate = Color.red
	pass

func _draw():
	if selected:
		draw_circle(Vector2(0,0), attack_range, Color(0, 1, 1, .25))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !current_target:
		select_target()
	else:
		if(!current_target.get_ref()):
			current_target = null
			$ShotTimer.set_paused(true)
			select_target()
		else:
			pass
			#look_at(current_target.get_ref())
	rotation += .1
	$Projectiles.rotation = (-rotation)
	
func flag_selection(is_being_selected: bool):
	selected = is_being_selected
	update()
	
func select_target():
	#target first (there are cases where this will not target the frontmost enemy, such as changing their paths)
	if enemy_array.size() > 0:
		current_target = weakref(enemy_array[0])
#	for target in enemy_array:
#		#currently a very scuffed targetting system
#		current_target = weakref(target)
	if current_target:
		$ShotTimer.set_paused(false)


func _on_attack_range_area_entered(area):
	if area.is_in_group("baddies"):
		enemy_array.append(area)


func _on_attack_range_area_exited(area):
	if area.is_in_group("baddies"):
		enemy_array.erase(area)
		if current_target.get_ref() and area == current_target.get_ref():
			current_target = null
			$ShotTimer.set_paused(true)
			select_target()

func get_target():
	return current_target

func _on_ShotTimer_timeout():
	if current_target.get_ref():
		instance = shot.instance()
		instance.set_target(current_target.get_ref())
		#this projectile spawn will be somewhere different when I get full tower customization done
		instance.position = $ProjectileSpawn.position
		instance.velocity = Vector2(((randf()*2)-1),((randf()*2)-1)).normalized()*instablility
		#.get_global_transform() would go before origin except that these are children of the towers
		$Projectiles.add_child(instance)
