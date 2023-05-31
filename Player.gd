extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var dir = Vector2.RIGHT
var rotation_speed = 0.006
var rotation_vel = 0
var accel = 10
var max_speed = 5000
var friction = 0.01
var rot_friction = 0.20
var traction = "road"
var on_wal_counter = 0
var accel_hamper = pow(10, 10)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var can_hit_wall = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var vel_speed = abs(vel.x) + abs(vel.y)
#	speed /= vel_speed/accel_hamper + 1
	
#	speed = clamp(max_speed, 0, speed)
	
	if traction == "road":
		max_speed = 1000
		
	if Input.is_action_pressed("ui_up"):
		vel += Vector2.UP.rotated(dir.angle()) * accel
	if Input.is_action_pressed("ui_down"):
		vel += Vector2.DOWN.rotated(dir.angle()) * accel
	if Input.is_action_pressed("ui_left"):
		rotation_vel -= rotation_speed * (abs(vel.y) + abs(vel.x))/1000
	if Input.is_action_pressed("ui_right"):
		rotation_vel += rotation_speed * (abs(vel.y) + abs(vel.x))/1000
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		if(on_wal_counter == 1):
			vel.x *= -1
			vel.y *= -1
		elif abs(vel.y) < abs(vel.x):
			vel.x /= 2
			vel.y /= -2
			on_wal_counter += 1
		else:
			vel.x /= -2
			vel.y /= 2
			on_wal_counter += 1
	else:
		on_wal_counter = 0
	
	
	
	rotation_vel *= (1.0 - rot_friction)
	
	dir = dir.rotated(rotation_vel)
	
	rotation = dir.angle()
	
	vel *= (1.0 - friction)

	var collision = move_and_collide(vel * delta)
	if collision and can_hit_wall:
		vel *= 0.97
		$Timer.start()
		can_hit_wall = false
	$Label.text = vel as String


func _on_Timer_timeout():
	can_hit_wall = true
