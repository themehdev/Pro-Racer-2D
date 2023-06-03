extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in $"%Track 1".get_children():
		if(i.name == "Start"):
			$Player.start_pos = i.position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
