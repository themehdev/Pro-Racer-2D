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
#func _process(delta):
#	pass



func _on_Menu_pressed():
	print("exit")
	get_tree().change_scene("res://Menu.tscn")
	hide()
	emit_signal("exiting")


func _on_Play_pressed():
	print("working")
	emit_signal("restart")
	hide()
