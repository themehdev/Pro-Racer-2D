extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var checkpoints_left = 0
var total_checkpoints = 0
var player
var num_tracks = 3
var track_playing = -1
var tracks = [{"track": "", "best_run": {"time": 0}, "time": {"time": 0, "inputs": [], "splits": []}}, {"track": "", "best_run": {"time": 0}, "time": {"time": 0, "inputs": [], "splits": []}}, {"track": "", "best_run": {"time": 0}, "time": {"time": 0, "inputs": [], "splits": []}}]
var best_time = {"time": 0}
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in num_tracks:
		tracks[i]["track"] = load("res://Tracks/Track " + (i + 1) as String + ".tscn")

func process(delta):
	if track_playing != -1:
		best_time = tracks[track_playing]["best_run"]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
