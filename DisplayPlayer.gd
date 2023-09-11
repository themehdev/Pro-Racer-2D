extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var color

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.color = color
	$ColorRect2.color = color
	$ColorRect3.color = color
	$ColorRect4.color = color
	$ColorRect5.color = color
	$ColorRect6.color = color
	$Polygon2D.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
