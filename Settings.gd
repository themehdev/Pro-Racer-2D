extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/HBoxContainer/VBoxContainer2/HSlider.value = Global.sound + 75
	$Popup/VBoxContainer/VBoxContainer/Label/DisplayPlayer.color = Color8(Global.colR, Global.colG, Global.colB)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	$Popup.popup()

func _on_Button_pressed():
	get_tree().change_scene("res://Menus/Start Menu.tscn")
	queue_free()

func _on_close_pressed():
	$Popup.hide()


func _on_HSlider_drag_ended(value_changed):
	Global.sound = $VBoxContainer/HBoxContainer/VBoxContainer2/HSlider.value - 75
	Global.save_to_file({"sound" : $VBoxContainer/HBoxContainer/VBoxContainer2/HSlider.value - 75}, "sound")

func _on_ColorPicker_color_changed(color):
	Global.colR = color.r8
	Global.colG = color.g8
	Global.colB = color.b8
	Global.save_to_file({"r": color.r8, "g": color.g8, "b": color.b8}, "color")
	$Popup/VBoxContainer/VBoxContainer/Label/DisplayPlayer.color = color
