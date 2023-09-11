extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.player.finishing == true:
		get_tree().change_scene("res://Menus/Start Menu.tscn")
