extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_tree().change_scene("res://Menus/Main Menu.tscn")
	$DisplayPlayer3.color = Color("640000ff")
	$DisplayPlayer2.color = Color("64ff6400")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Menus/Main Menu.tscn")



func _on_Stats_pressed():
	get_tree().change_scene("res://Stats.tscn")
