extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Beginner_pressed():
	Global.sec_playing = "Beginner"
	get_tree().change_scene("res://Menu.tscn")
	queue_free()



func _on_Intermediate_pressed():
	Global.sec_playing = "Intermediate"
	get_tree().change_scene("res://Menu.tscn")
	queue_free()


func _on_Accomplished_pressed():
	Global.sec_playing = "Accomplished"
	get_tree().change_scene("res://Menu.tscn")
	queue_free()


func _on_Advanced_pressed():
	Global.sec_playing = "Advanced"
	get_tree().change_scene("res://Menu.tscn")
	queue_free()


func _on_Master_pressed():
	Global.sec_playing = "Master"
	get_tree().change_scene("res://Menu.tscn")
	queue_free()
