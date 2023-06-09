extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tracks = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.tracks:
		var button = $GridContainer/Base.duplicate()
		button.visible = true
		button.text = "Track " + (i + 1) as String
		button.connect("button_up", self, "_button_pressed", [i])
		$GridContainer.add_child(button)

func _button_pressed(id):
	Global.track_playing = id
	get_tree().change_scene("res://Game.tscn")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
