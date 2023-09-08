extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TracksGotten.text = "You have beaten the official time on\n" + ((Global.sec_has - 1) * 5) as String + " tracks."
	$VBoxContainer/LiveWins.text = "You have won " + (Global.live_wins) as String + " live races."
	$VBoxContainer/LiveLosses.text = "You have lost " + (Global.live_races - Global.live_wins) as String + " live races."
	$VBoxContainer/LiveWinPercentage.text = "You have won " + (round(Global.live_wins * 100/Global.live_races) if Global.live_races != 0 else "N/A") as String + " percent of live races."


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://Menus/Start Menu.tscn")
	queue_free()
