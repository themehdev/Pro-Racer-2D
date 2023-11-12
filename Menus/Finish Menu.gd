extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal restart
signal exiting

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/Next.disabled = Global.sec_has < Global.name_to_num(Global.sec_playing) + 0.9 and Global.track_playing == 4



func _on_Menu_pressed():
	print("exit")
	get_tree().change_scene("res://Menus/Menu.tscn")
	hide()
	emit_signal("exiting")


func _on_Play_pressed():
	print("working")
	if Global.opp_type != "live":
		emit_signal("restart")
	else:
		get_tree().change_scene("res://Connection.tscn")
	hide()


func _on_Next_pressed():
	if Global.track_playing != 4:
		Global.track_playing += 1
		get_tree().change_scene("res://Menus/Track Menu.tscn")
		queue_free()
	else:
		Global.sec_playing = Global.num_to_name_2(Global.name_to_num(Global.sec_playing) + 1)
		Global.track_playing = 0
		get_tree().change_scene("res://Menus/Track Menu.tscn")
		queue_free()
