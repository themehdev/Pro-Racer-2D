extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.sec_has = 1
	for i in Global.num_tracks:
		if Global.pb_times["Beginner"][i]["time"] < Global.official_times["Beginner"][i]["time"] and Global.pb_times["Beginner"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Beginner"][i]["time"] < world_times["Beginner"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Beginner/" + i as String + ".json", Global.pb_times["Beginner"][i])
			#print(Global.sec_has)
		if Global.pb_times["Intermediate"][i]["time"] < Global.official_times["Intermediate"][i]["time"] and Global.pb_times["Intermediate"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Intermediate"][i]["time"] < world_times["Intermediate"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Intermediate/" + i as String + ".json", Global.pb_times["Intermediate"][i])
		if Global.pb_times["Accomplished"][i]["time"] < Global.official_times["Accomplished"][i]["time"] and Global.pb_times["Accomplished"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Accomplished"][i]["time"] < world_times["Accomplished"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Accomplished/" + i as String + ".json", Global.pb_times["Accomplished"][i])
		if Global.pb_times["Advanced"][i]["time"] < Global.official_times["Advanced"][i]["time"] and Global.pb_times["Advanced"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Advanced"][i]["time"] < world_times["Advanced"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Advanced/" + i as String + ".json", Global.pb_times["Advanced"][i])
		if Global.pb_times["Professional"][i]["time"] < Global.official_times["Professional"][i]["time"] and Global.pb_times["Professional"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Professional"][i]["time"] < world_times["Professional"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Professional/" + i as String + ".json", Global.pb_times["Professional"][i])
	$VBoxContainer/Intermediate.disabled = Global.sec_has < 1.9
	$VBoxContainer/Accomplished.disabled = Global.sec_has < 2.9
	$VBoxContainer/Advanced.disabled = Global.sec_has < 3.9
	$VBoxContainer/Professional.disabled = Global.sec_has < 4.9


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/Intermediate.disabled = Global.sec_has < 1.9
	$VBoxContainer/Accomplished.disabled = Global.sec_has < 3
	$VBoxContainer/Advanced.disabled = Global.sec_has < 4
	$VBoxContainer/Professional.disabled = Global.sec_has < 5



func _on_Beginner_pressed():
	Global.sec_playing = "Beginner"
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()



func _on_Intermediate_pressed():
	Global.sec_playing = "Intermediate"
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()


func _on_Accomplished_pressed():
	Global.sec_playing = "Accomplished"
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()


func _on_Advanced_pressed():
	Global.sec_playing = "Advanced"
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()


func _on_Professional_pressed():
	Global.sec_playing = "Professional"
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()


func _on_Clear_pressed():
	Global.pb_times =  {"Beginner": [], "Intermediate": [], "Accomplished": [], "Advanced": [], "Professional": []}
	for i in Global.num_tracks:
		Global.pb_times["Beginner"].append({"time":0})
		Global.pb_times["Intermediate"].append({"time":0})
		Global.pb_times["Accomplished"].append({"time":0})
		Global.pb_times["Advanced"].append({"time":0})
		Global.pb_times["Professional"].append({"time":0})
	Global.save_to_file(Global.pb_times, "pb_times")
	Global.sec_has = 1
	for i in Global.num_tracks:
		if Global.pb_times["Beginner"][i]["time"] < Global.official_times["Beginner"][i]["time"] and Global.pb_times["Beginner"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Beginner"][i]["time"] < world_times["Beginner"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Beginner/" + i as String + ".json", Global.pb_times["Beginner"][i])
			#print(Global.sec_has)
		if Global.pb_times["Intermediate"][i]["time"] < Global.official_times["Intermediate"][i]["time"] and Global.pb_times["Intermediate"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Intermediate"][i]["time"] < world_times["Intermediate"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Intermediate/" + i as String + ".json", Global.pb_times["Intermediate"][i])
		if Global.pb_times["Accomplished"][i]["time"] < Global.official_times["Accomplished"][i]["time"] and Global.pb_times["Accomplished"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Accomplished"][i]["time"] < world_times["Accomplished"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Accomplished/" + i as String + ".json", Global.pb_times["Accomplished"][i])
		if Global.pb_times["Advanced"][i]["time"] < Global.official_times["Advanced"][i]["time"] and Global.pb_times["Advanced"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Advanced"][i]["time"] < world_times["Advanced"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Advanced/" + i as String + ".json", Global.pb_times["Advanced"][i])
		if Global.pb_times["Professional"][i]["time"] < Global.official_times["Professional"][i]["time"] and Global.pb_times["Professional"][i]["time"] != 0:
			Global.sec_has += 0.2
#				if Global.pb_times["Professional"][i]["time"] < world_times["Professional"][i]["time"]:
#					_make_post_request(URL_WORLD + "/Professional/" + i as String + ".json", Global.pb_times["Professional"][i])


func _on_Back_pressed():
	get_tree().change_scene("res://Menus/Start Menu.tscn")
	queue_free()
