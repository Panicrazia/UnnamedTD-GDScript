extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var countdown_var

func _ready():
	connect("timeout", self, "countdown")

func countdown():
	countdown_var-=1
	if countdown_var <= 0:
		print("committing seppuku")
		queue_free()
