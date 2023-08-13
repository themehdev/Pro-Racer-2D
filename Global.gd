extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var checkpoints_left = 0
var total_checkpoints = 0
var player
var num_tracks = 5
var track_has_finish = true
var sec_playing = 0
var track_playing = -1
var times_to_beat = {"Beginner": [0, 0, 0, 0, 0], "Intermediate": [0, 0, 0, 0, 0], "Accomplished": [0, 0, 0, 0, 0], "Advanced": [0, 0, 0, 0, 0], "Professional": [0, 0, 0, 0, 0]}
var tracks = {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
var best_time = {"time": 0}

func gen_time(time):
	return  (floor(time/60) if time >= 0 else ceil(time/60)) as String + ":" + (abs(fmod(time, 60.0)) as String if fmod(time, 60.0) > 10 else ("0" + abs(fmod(time, 60.0)) as String))
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_tracks:
		tracks["Beginner"].append({"track": load("res://Tracks/Beginner/Track " + (i + 1) as String + ".tscn"), "best_run": {"time": 0}, "time": times_to_beat["Beginner"][i]})
	for i in num_tracks:
		tracks["Intermediate"].append({"track": load("res://Tracks/Intermediate/Track " + (i + 1) as String + ".tscn"), "best_run": {"time": 0}, "time": times_to_beat["Intermediate"][i]})
	for i in num_tracks:
		tracks["Accomplished"].append({"track": load("res://Tracks/Accomplished/Track " + (i + 1) as String + ".tscn"), "best_run": {"time": 0}, "time": times_to_beat["Accomplished"][i]})
	for i in num_tracks:
		tracks["Advanced"].append({"track": load("res://Tracks/Advanced/Track " + (i + 1) as String + ".tscn"), "best_run": {"time": 0}, "time": times_to_beat["Advanced"][i]})
	for i in num_tracks:
		tracks["Professional"].append({"track": load("res://Tracks/Professional/Track " + (i + 1) as String + ".tscn"), "best_run": {"time": 0}, "time": times_to_beat["Professional"][i]})
	

#func process(delta):
#	if track_playing != -1:
#		best_time = tracks[track_playing]["best_run"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
