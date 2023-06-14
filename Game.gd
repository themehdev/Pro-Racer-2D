extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var yay = false
var happened = false
var tracks = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(Global.track_playing)
#	print(Global.tracks[Global.track_playing]["track"])
	add_child(Global.tracks[Global.track_playing]["track"].instance())

func _process(delta):
	if yay:
		for i in get_child(2).get_children():
			if(i.name == "Start"):
				get_tree().call_group("Player", "set_start", i.position)
		yay = false
		happened = true
	elif not happened:
		yay = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
