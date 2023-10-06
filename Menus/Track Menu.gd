extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/World.disabled = Global.official_times[Global.sec_playing][Global.track_playing]["time"] < Global.pb_times[Global.sec_playing][Global.track_playing]["time"] or Global.pb_times[Global.sec_playing][Global.track_playing]["time"] == 0
	$VBoxContainer/Title.text = Global.sec_playing + " " + (Global.track_playing + 1) as String + " -  " + Global.num_to_name(Global.track_playing + 1)
	if Global.pb_times[Global.sec_playing][Global.track_playing]["time"] != 0:
		$VBoxContainer/PB.text += "\n | Time: " + Global.gen_time(Global.pb_times[Global.sec_playing][Global.track_playing]["time"]) as String
	$VBoxContainer/Official.text += "\n | Time: " + Global.gen_time(Global.official_times[Global.sec_playing][Global.track_playing]["time"]) as String
	$VBoxContainer/World.text += "\n | Time: " + Global.gen_time(Global.world_times[Global.sec_playing][Global.track_playing]["time"]) as String
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PB_pressed():
	Global.opp_type = ""
	get_tree().change_scene("res://Game.tscn")
	queue_free()


func _on_Official_pressed():
	Global.opp_type = "official"
	get_tree().change_scene("res://Game.tscn")
	queue_free()


func _on_World_pressed():
	Global.opp_type = "world"
	get_tree().change_scene("res://Game.tscn")
	queue_free()


func _on_Live_pressed():
	#Global.opp_type = "live"
	get_tree().change_scene("res://Connection.tscn")
	queue_free()


func _on_Back_pressed():
	get_tree().change_scene("res://Menus/Menu.tscn")
	queue_free()
