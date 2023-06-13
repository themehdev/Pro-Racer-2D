extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var yay = false
var happened = false
var tracks = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.num_tracks:
		tracks.append(Global.tracks[i]["track"])
	add_child(tracks[Global.track_playing])

func _process(delta):
	if yay:
		for i in get_child(2).get_children():
			if(i.name == "Start"):
				$Player.start_pos = i.position# + Vector2(0, -512)
				$Player.last_cp_pos = i.position# + Vector2(0, -512)
				$GhostPlayer.start_pos = i.position# + Vector2(0, -512)
				$GhostPlayer.last_cp_pos = i.position# + Vector2(0, -512)
		yay = false
		happened = true
	elif not happened:
		yay = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
