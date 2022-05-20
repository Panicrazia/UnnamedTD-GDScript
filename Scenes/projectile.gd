extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 5
var effects = []
var target = null
var velocity = Vector2.ZERO
var speed_increment = .04
var speed = speed_increment * -5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if speed < 1:
			speed += speed_increment
	if (target != null) and (target.get_ref()):
		if speed < 0:
			velocity*=.99
			pass
		else:
			var prediction = Vector2.RIGHT.rotated(target.get_ref().get_parent().rotation) * delta * target.get_ref().get_parent().speed
			var pull = clamp(1000/(target.get_ref().get_global_transform().origin - get_global_transform().origin).length_squared(), 0, 1)
			velocity *= (1-pull)
			velocity += ((target.get_ref().get_global_transform().origin + prediction - get_global_transform().origin)).normalized()*800*speed*pull
			pass
	else:
		target = get_parent().get_parent().get_target()
		#ask parent for a new target or do whatever idk im not your boss
	position += velocity * delta

#projectiles should look at their parent for a target, since the tower will be their daddy and will always have what its currently targeting

func _on_projectile_area_entered(area):
	if area.is_in_group("baddies"):
		if ((target != null) and (area == target.get_ref())):
			area.get_parent().damage(damage)
			area.get_parent().doEffects(effects)
			queue_free()
		

func set_target(targetToSet):
	target = weakref(targetToSet)
