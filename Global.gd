extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var checkpoints_left = 0
var total_checkpoints = 0
var player = {"finishing": false, "physics": false, "timer": 0}
var num_tracks = 5
var track_has_finish = true
var sec_playing = "Beginner"
var track_playing = -1
var tracks = {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
var official_times =  {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
var world_times =  {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
var pb_times =  {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
var best_run = {"time": 0}
var opp_type = "-"
var opp_run
var URL_OFFICIAL = "https://pro-racer-2d-default-rtdb.firebaseio.com/Official.json"
var URL_WORLD = "https://pro-racer-2d-default-rtdb.firebaseio.com/World"
var sec_has = 0
var can_play_world = false

func gen_time(time):
	return  (floor(time/60) if time >= 0 else ceil(time/60)) as String + ":" + (abs(fmod(time, 60.0)) as String if fmod(time, 60.0) > 10 else ("0" + abs(fmod(time, 60.0)) as String))
# Called when the node enters the scene tree for the first time.
func vec2_to_xy(vec2):
	return {"x": vec2.x, "y": vec2.y}
func xy_to_vec2(obj):
	return Vector2(obj["x"], obj["y"])
	
func num_to_name(num):
	if(num == 1):
		return "Race"
	elif(num == 2):
		return "Road"
	elif(num == 3):
		return "Dirt"
	elif(num == 4):
		return "Precision"
	elif(num == 5):
		return "Lap"
	else: 
		return "Houston, we have a problem"

func _ready():
	for i in num_tracks:
		tracks["Beginner"].append(load("res://Tracks/Beginner/Track " + (i + 1) as String + ".tscn"))
		pb_times["Beginner"].append({"time":0})
		tracks["Intermediate"].append(load("res://Tracks/Intermediate/Track " + (i + 1) as String + ".tscn"))
		pb_times["Intermediate"].append({"time":0})
		tracks["Accomplished"].append(load("res://Tracks/Accomplished/Track " + (i + 1) as String + ".tscn"))
		pb_times["Accomplished"].append({"time":0})
		tracks["Advanced"].append(load("res://Tracks/Advanced/Track " + (i + 1) as String + ".tscn"))
		pb_times["Advanced"].append({"time":0})
		tracks["Professional"].append(load("res://Tracks/Professional/Track " + (i + 1) as String + ".tscn"))
		pb_times["Professional"].append({"time":0})
	$HTTPRequest.request(URL_OFFICIAL)
	
func _make_post_request(url, data_to_send, use_ssl = false):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_PUT, query)

var got_stuff = "official"

func _process(delta):
	if opp_type == "official":
		opp_run = official_times[sec_playing][track_playing]
	elif opp_type == "world":
		opp_run = world_times[sec_playing][track_playing]
	if opp_type != "-" and opp_type != "":
		#print(pb_times[sec_playing][track_playing]["time"])
		best_run = pb_times[sec_playing][track_playing] if (pb_times[sec_playing][track_playing]["time"] != 0 and pb_times[sec_playing][track_playing]["time"] <= opp_run["time"]) else opp_run
	else:
		best_run = pb_times[sec_playing][track_playing]
	sec_has = 1
	if got_stuff == "":
		for i in num_tracks:
			if pb_times["Beginner"][i]["time"] < official_times["Beginner"][i]["time"] and pb_times["Beginner"][i]["time"] != 0:
				sec_has += 0.2
#				if pb_times["Beginner"][i]["time"] < world_times["Beginner"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Beginner/" + i as String + ".json", pb_times["Beginner"][i])
				#print(sec_has)
			if pb_times["Intermediate"][i]["time"] < official_times["Intermediate"][i]["time"] and pb_times["Intermediate"][i]["time"] != 0:
				sec_has += 0.2
#				if pb_times["Intermediate"][i]["time"] < world_times["Intermediate"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Intermediate/" + i as String + ".json", pb_times["Intermediate"][i])
			if pb_times["Accomplished"][i]["time"] < official_times["Accomplished"][i]["time"] and pb_times["Accomplished"][i]["time"] != 0:
				sec_has += 0.2
#				if pb_times["Accomplished"][i]["time"] < world_times["Accomplished"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Accomplished/" + i as String + ".json", pb_times["Accomplished"][i])
			if pb_times["Advanced"][i]["time"] < official_times["Advanced"][i]["time"] and pb_times["Advanced"][i]["time"] != 0:
				sec_has += 0.2
#				if pb_times["Advanced"][i]["time"] < world_times["Advanced"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Advanced/" + i as String + ".json", pb_times["Advanced"][i])
			if pb_times["Professional"][i]["time"] < official_times["Professional"][i]["time"] and pb_times["Professional"][i]["time"] != 0:
				sec_has += 0.2
#				if pb_times["Professional"][i]["time"] < world_times["Professional"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Professional/" + i as String + ".json", pb_times["Professional"][i])
#	print(sec_has)
#	if sec_has >= 2:
#		#print(pb_times["Advanced"][1]["time"])
#		print("posting")
#		_make_post_request("https://pro-racer-2d-default-rtdb.firebaseio.com/Official/Accomplished.json", pb_times["Accomplished"])
#		pb_times["Accomplished"][1] = {"time":0}
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if got_stuff == "official":
		official_times = JSON.parse(body.get_string_from_utf8()).result
		got_stuff = "world"
		_make_post_request(URL_WORLD + ".json", official_times)
	elif got_stuff == "world":
		world_times = JSON.parse(body.get_string_from_utf8()).result
		got_stuff = ""
		print("done with getting data")

	#print("why")
