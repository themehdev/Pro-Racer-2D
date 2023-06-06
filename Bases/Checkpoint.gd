extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gotten = false

func reset():
	if gotten:
		Global.checkpoints_left += 1
		Global.total_checkpoints += 1
	gotten = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.checkpoints_left += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


