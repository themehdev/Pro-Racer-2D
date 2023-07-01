extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("player"):
		Global.roads_on += 1

func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group("player"):
		Global.roads_on -= 1
