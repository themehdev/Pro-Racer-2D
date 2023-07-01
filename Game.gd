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
		Global.track_has_finish = false
		for i in get_child(2).get_children():
			if("Start" == i.name):
				get_tree().call_group("Player", "set_start", [i.position, i.rotation])
			if("Finish" in i.name):
				Global.track_has_finish = true
		yay = false
		happened = true
	elif not happened:
		yay = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
