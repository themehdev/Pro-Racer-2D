extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2(0, 0)
var dir = Vector2.RIGHT
var rotation_speed = 0.006
var rotation_vel = 0
var accel = 22.5
var b_accel = 15
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
var just_had_collision = false
var just_went = true
var start = 3
var physics = false


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
	var vel_speed = abs(vel.x) + abs(vel.y)
	$"%Start Text".text = ceil($Start.time_left) as String if $Start.time_left != 0 else "Go!"
	
	if timer > 1:
		$"%Start Text".visible = false
#	speed /= vel_speed/accel_hamper + 1
	
#	speed = clamp(max_speed, 0, speed)
	
	if Input.is_action_pressed("respawn"):
		$"%Start Text".visible = true
		position = Vector2.ZERO
		vel = Vector2.ZERO
		dir = Vector2.RIGHT
		physics = false
		$Start.start()
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
		rotation_vel -= rotation_speed * vel_speed/vel_to_turn_divisor
	if Input.is_action_pressed("ui_right"):
		drift_turn_speed = 0.003
		rotation_vel += rotation_speed * vel_speed/vel_to_turn_divisor
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
	
	#$Label.text = Global.checkpoints_left as String
	traction = traction_types[traction_type]
	
	dir = dir.rotated(rotation_vel)
	
	vel = vel.rotated(rotation_vel * traction * (1.0 - drift)) 
	
	
	vel *= (1.0 - friction)
	if physics:
		rotation = dir.angle()
		collision = move_and_collide(vel * delta)
		timer += round(delta * 1000)/1000
		$Label2.text = "Time: " + timer as String
	
	if(collision and just_had_collision):
		can_hit_wall = false
		$HitWall.stop()
	elif (not collision and $HitWall.time_left == 0 and not just_went):
		$HitWall.start()
	print($HitWall.time_left)
	if collision and can_hit_wall:
#		rotation_vel += 0.1 * vel.length() * 0.002 * collision.normal.dot(vel.normalized())
		var coll_angle = collision.get_angle(dir.normalized()) if collision.get_angle(dir.normalized()) <= PI/2 else collision.get_angle(dir.normalized()) - PI
		if(abs(coll_angle) <= PI/4.75):
			rotation_vel += coll_angle/2
#		elif(collision.get_angle(vel) > PI/6 and collision.get_angle(vel.normalized()) <= PI/4):
#			rotation_vel += PI/2
		else:
			rotation_vel += -(PI/2 * sign(coll_angle) - coll_angle)/4
		can_hit_wall = false
		just_had_collision = true
		just_went = false
		vel /= 2


func _on_HitWall_timeout():
	can_hit_wall = true
	just_had_collision = false
	just_went = true
	print("running")

func _on_Area2D_area_entered(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter += 1
	if (parent.is_in_group("Dirt")):
		dirt_counter += 1
	if (parent.is_in_group("Checkpoint")):
		Global.checkpoints_left -= 1
		$Label.text = timer as String
	if ((parent.is_in_group("Finish")) and Global.checkpoints_left == 0):
		$Label.text = "Finish!: " + timer as String
		
func _on_Area2D_area_exited(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter -= 1
	if (parent.is_in_group("Dirt")):
		dirt_counter -= 1

func _on_Start_timeout():
	physics = true
	vel = Vector2.ZERO
	position = Vector2.ZERO
	dir = Vector2.RIGHT
