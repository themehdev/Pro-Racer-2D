extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var dir = Vector2(0, -1)
var rotation_speed = 0.004
var rotation_vel = 0
var speed = 70
var friction = 0.05
var rot_friction = 0.20
var grip = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		vel += Vector2.UP.rotated(dir.angle()) * speed
	if Input.is_action_pressed("ui_down"):
		vel += Vector2.DOWN.rotated(dir.angle()) * speed
	if Input.is_action_pressed("ui_left"):
		rotation_vel -= rotation_speed
		vel = vel.rotated(dir.angle() - PI/60)
	if Input.is_action_pressed("ui_right"):
		rotation_vel += rotation_speed
		vel = vel.rotated(dir.angle() - PI/60)
	if is_on_ceiling() or is_on_floor():
		vel.y /= 2
		vel.x /= 2
	
	dir = dir.rotated(rotation_vel)
	
	rotation = dir.angle()
	
	vel *= (1.0 - friction)
	rotation_vel *= (1.0 - rot_friction)

	move_and_slide(vel)
	
