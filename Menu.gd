extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tracks = []


# Called when the node enters the scene tree for the first time.
func _ready():
#	for i in Global.num_tracks:
#		Global.tracks[i]["track"] = load("res://Tracks/Track " + (i + 1) as String + ".tscn").instance()
	Global.track_playing = -1
	Global.opp_type = "-"
	for i in Global.num_tracks:
		var button = $GridContainer/Back.duplicate()
		button.visible = true
		button.text = Global.sec_playing + " " + (i + 1) as String + " - " + Global.num_to_name(i + 1)
#		if Global.pb_times[Global.sec_playing][i]["time"] != 0:
#			button.text += "\n  PB time: " + Global.gen_time(Global.pb_times[Global.sec_playing][i]["time"]) as String
		button.connect("button_up", self, "_button_pressed", [i])
		$GridContainer.add_child(button)

func _button_pressed(id):
	Global.track_playing = id
	get_tree().change_scene("res://Track Menu.tscn")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Back_pressed():
	Global.track_playing = -1
	get_tree().change_scene("res://Main Menu.tscn")
	queue_free()
