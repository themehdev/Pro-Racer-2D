extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var dir = Vector2(0, -1)
var rotation_speed = 0.05
var speed = 5
var friction = 0.02

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_ceiling() or is_on_floor():
		vel.y = 0
	if Input.is_action_pressed("ui_up"):
		vel += Vector2.UP.rotated(dir.angle()) * speed
	if Input.is_action_pressed("ui_down"):
		vel += Vector2.DOWN.rotated(dir.angle()) * speed
	if Input.is_action_pressed("ui_left"):
		dir = dir.rotated(-rotation_speed)
	if Input.is_action_pressed("ui_right"):
		dir = dir.rotated(rotation_speed)
	
	rotation = dir.angle()
	
	vel *= (1.0 - friction)

	move_and_slide(vel)
	
