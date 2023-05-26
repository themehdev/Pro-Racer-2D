extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		vel.y -= 1
	if Input.is_action_pressed("ui_down"):
		vel.y += 1
	if Input.is_action_pressed("ui_left"):
		vel.x += 0.05 * vel.y
		vel.y -= 0.05 * vel.y
	if Input.is_action_pressed("ui_right"):
		vel.x -= 0.05 * vel.y
		vel.y += 0.05 * vel.y
	
	position += vel
