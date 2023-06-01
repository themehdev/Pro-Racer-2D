extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var dir = Vector2.RIGHT
var rotation_speed = 0.006
var rotation_vel = 0
var accel = 20
var b_accel = 12
var max_speed = 20000
var friction = 0.01
var rot_friction = 0.20
var traction_type = "road"
var traction = 0.9
var on_wal_counter = 0
var accel_hamper = pow(10, 10)
var is_trying_to_move = false
var drift = 0
var drifting = false
var min_drift_speed = 0
var drift_turn_speed = 0.005
var collision
var vel_to_turn_divisor = 800
var road_counter = 0
var dirt_counter = 0
var timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var can_hit_wall = true

var traction_types = {
	"road": 0.9,
	"dirt": 0.5,
	"drift": 0.1,
	"off_road": 0.15
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer += delta/1000
	$Label2.text = timer as String
	var vel_speed = abs(vel.x) + abs(vel.y)
	
#	speed /= vel_speed/accel_hamper + 1
	
#	speed = clamp(max_speed, 0, speed)
	
		
	if Input.is_action_pressed("ui_up"):
		vel += Vector2.UP.rotated(dir.angle()) * accel
		is_trying_to_move = true
	if Input.is_action_pressed("ui_down"):
		vel += Vector2.DOWN.rotated(dir.angle()) * b_accel
		if vel.length_squared() > min_drift_speed * min_drift_speed and abs(rotation_vel) > 0.01:
			drifting = true
		is_trying_to_move = true
	drift_turn_speed = 0
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		is_trying_to_move = false
	if Input.is_action_pressed("ui_left"):
		drift_turn_speed = -0.003
		rotation_vel -= rotation_speed * (abs(vel.y) + abs(vel.x))/vel_to_turn_divisor
	if Input.is_action_pressed("ui_right"):
		drift_turn_speed = 0.003
		rotation_vel += rotation_speed * (abs(vel.y) + abs(vel.x))/vel_to_turn_divisor
	if(is_trying_to_move):
		friction = 0.015
	else:
		friction = 0.005
	
	if(road_counter > 0):
		traction_type = "road"
	elif (dirt_counter > 0): 
		traction_type = "dirt"
		friction = 0.012
	else:
		traction_type = "off_road"
		friction = 0.02
	
	rotation_vel *= (1.0 - rot_friction)
	
	if abs(rotation_vel) < 0.01 or vel_speed < 20 or vel * Vector2.UP.rotated(dir.angle()) < Vector2.ZERO or collision or traction_type == "off_road":
		drifting = false
	
	if drifting:
		drift = 0.5
		friction = 0.03
		rotation_vel += drift_turn_speed
		traction_type = "drift"
	else:
		drift = 0
	
	$Label.text = traction_type as String
	traction = traction_types[traction_type]
	
	dir = dir.rotated(rotation_vel)
	
	vel = vel.rotated(rotation_vel * traction * (1.0 - drift)) 
	
	rotation = dir.angle()
	
	vel *= (1.0 - friction)

	collision = move_and_collide(vel * delta)
	if collision and can_hit_wall:
		vel = vel.bounce(collision.normal) * (1.0 - abs(collision.normal.dot(vel.normalized()))) * 0.7
		$HitWall.start()
		can_hit_wall = false


func _on_HitWall_timeout():
	can_hit_wall = true

func _on_Area2D_area_entered(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter += 1
	if (parent.is_in_group("Dirt")):
		dirt_counter += 1
	if (parent.is_in_group("Checkpoint")):
		Global.checkpoints_left -= 1
	if (parent.is_in_group("Finish") and Global.checkpoints_left == 0):
		$Label.text = "Finish!"
		
func _on_Area2D_area_exited(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter -= 1
	if (parent.is_in_group("Dirt")):
		dirt_counter -= 1
