extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tracks = []


# Called when the node enters the scene tree for the first time.
func _ready():
#	for i in Global.num_tracks:
#		Global.tracks[i]["track"] = load("res://Tracks/Track " + (i + 1) as String + ".tscn").instance()
	$GridContainer/Title.text = Global.sec_playing + " track set:"
	Global.track_playing = -1
	Global.opp_type = "-"
	for i in Global.num_tracks:
		var button = $GridContainer/Back.duplicate()
		button.visible = true
		button.text = Global.sec_playing + " " + (i + 1) as String + " - " + Global.num_to_name(i + 1)
		if Global.pb_times[Global.sec_playing][i]["time"] < Global.official_times[Global.sec_playing][i]["time"] and Global.pb_times[Global.sec_playing][i]["time"] != 0:
			var nbox = StyleBoxFlat.new()
			nbox.bg_color = Color("1f3222")
			var hbox = StyleBoxFlat.new()
			hbox.bg_color = Color("163d11")
			button["custom_styles/normal"] = nbox
			button["custom_styles/hover"] = hbox 
#		if Global.pb_times[Global.sec_playing][i]["time"] != 0:
#			button.text += "\n  PB time: " + Global.gen_time(Global.pb_times[Global.sec_playing][i]["time"]) as String
		button.connect("button_up", self, "_button_pressed", [i])
		$GridContainer.add_child(button)

func _button_pressed(id):
	Global.track_playing = id
	get_tree().change_scene("res://Menus/Track Menu.tscn")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Back_pressed():
	Global.track_playing = -1
	get_tree().change_scene("res://Menus/Main Menu.tscn")
	queue_free()
