extends Sprite

var turn_speed = PI

func _process(delta):
	var direction = 0
	
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
		
	rotation += turn_speed * delta * direction
	
