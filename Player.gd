extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_wall():
		vel.x = 0
	if is_on_ceiling() or is_on_floor():
		vel.y = 0
	if Input.is_action_pressed("ui_up"):
		vel.y -= 1
	if Input.is_action_pressed("ui_down"):
		vel.y += 1
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1
	if Input.is_action_pressed("ui_right"):
		vel.x += 1

	position += move_and_slide(vel)
	
