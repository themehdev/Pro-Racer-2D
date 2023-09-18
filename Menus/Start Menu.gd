extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().change_scene("res://Menus/Main Menu.tscn")
	$DisplayPlayer3.color = Color8(255 - Global.colR, 255 - Global.colG, 255 - Global.colB, 100)
	$DisplayPlayer2.color = Color8(Global.colR, Global.colG, Global.colB, 100)
	$DisplayPlayer.color = Color8(Global.colR, Global.colG, Global.colB)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Menus/Main Menu.tscn")

func _on_Stats_pressed():
	get_tree().change_scene("res://Stats.tscn")

func _on_Button_pressed():
	get_tree().change_scene("res://Settings.tscn")
