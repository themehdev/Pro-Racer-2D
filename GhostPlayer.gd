extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lap = 1
var vel = Vector2(0, 0)
var dir = Vector2.RIGHT
var boost_vel = 100
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
var vel_to_turn_divisor = 950
var road_counter = 0
var dirt_counter = 0
var boost_counter = 0
var boost_dir = 0
var timer = 0
var just_had_collision = false
var just_went = true
var start = 3
var physics = false
var finishing = false
var turning = false
var input_on = 0
var local_cps = 0
var local_inputs
var just_changed = false
#var old_run
var can_hit_wall = true
var type = "pb"

var traction_types = {
	"road": 0.9,
	"dirt": 0.5,
	"drift": 0.1,
	"off_road": 0.15
}

onready var start_pos = Vector2.ZERO
onready var last_cp_pos = start_pos
onready var start_dir = Vector2.RIGHT
onready var last_cp_dir = Vector2.RIGHT
onready var run = data[Global.sec_playing][Global.track_playing]
var input_len = 0
var data = Global.pb_times



# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_pos
	visible = false

func set_start(args):
	start_pos = args[0]
	last_cp_pos = args[0]
	start_dir = Vector2.RIGHT.rotated(args[1])
	last_cp_dir = Vector2.RIGHT.rotated(args[1])
	position = start_pos
	rotation = args[1]
	Input.action_press("restart")
	
func set_col(is_pb):
	var col = Color("64ff6400") if not is_pb else Color("640000ff")
	$Graphics/ColorRect.color = col
	$Graphics/ColorRect2.color = col
	$Graphics/ColorRect3.color = col
	$Graphics/ColorRect4.color = col
	$Graphics/ColorRect5.color = col
	$Graphics/ColorRect6.color = col
	$Graphics/Polygon2D.color = col
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#old_run = run
	set_col(type == "pb" or type == "")
	if type == "pb" or type == "":
		data = Global.pb_times
	elif type == "official":
		data = Global.official_times
	elif type == "world":
		data = Global.world_times
	if type == "" or (type == "pb" and Global.pb_times[Global.sec_playing][Global.track_playing]["time"] == 0):
		visible = false
	else:
		visible = true
	if run["time"] != 0:
		input_len = len(run["inputs"])
	if (data[Global.sec_playing][Global.track_playing]["time"] != 0 and run["time"] == 0) or input_on >= input_len - 1:
		physics = false
#		if not (Global.tracks[Global.track_playing]["best_run"]["time"] == 0 and run["time"] == 0) and input_on >= input_len - 1:
#
#			pass
		just_changed = true
		run = data[Global.sec_playing][Global.track_playing]
	
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[1])
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[0])
	if run["time"] != 0:
		visible = true
		if not Global.player.finishing:
			physics = Global.player.physics
			
		if physics and input_on < input_len - 2 and $Start.time_left == 0:
			input_on += 1
			
		local_inputs = run["inputs"][input_on]
		if physics:
			$Start.wait_time = 3
			position = Global.xy_to_vec2(local_inputs["pos"])
			rotation = local_inputs["dir"]
#		if Global.player.start_stopped and not Global.player.has_popup:
#			$Start.start()
#		if Input.is_action_just_pressed("pause"):
#			physics = false
#			if $Start.time_left != 0:
#				$Start.wait_time = $Start.time_left
#				$Start.stop()
			#print(position)
#		turning = false
#		var vel_speed = abs(vel.x) + abs(vel.y)
#	#	speed /= vel_speed/accel_hamper + 1
#	#	speed = clamp(max_speed, 0, speed)
#		if vel_speed > max_speed:
#			vel = vel.normalized() * (max_speed - 1)
#		if local_inputs["up"]:
#			vel += Vector2.UP.rotated(dir.angle()) * accel
#			is_trying_to_move = true
#		if local_inputs["down"]:
#			vel += Vector2.DOWN.rotated(dir.angle()) * b_accel
#			if vel.length_squared() > min_drift_speed * min_drift_speed and abs(rotation_vel) > 0.01:
#				drifting = true
#			is_trying_to_move = true
#		drift_turn_speed = 0
#		if not local_inputs["down"] and not local_inputs["up"]:
#			is_trying_to_move = false
#		if local_inputs["left"]:
#			drift_turn_speed = -0.003
#			turning = true
#			rotation_vel -= rotation_speed * vel_speed/vel_to_turn_divisor
#		if local_inputs["right"]:
#			drift_turn_speed = 0.003
#			turning = true
#			rotation_vel += rotation_speed * vel_speed/vel_to_turn_divisor
#		if local_inputs["respawn"] and last_cp_pos != start_pos and physics:
#			position = last_cp_pos
#			vel = Vector2.ZERO
#			rotation_vel = 0
#			dir = last_cp_dir
		if Global.player.timer == 0:
				#get_tree().call_group("Checkpoint", "reset")
				input_on = 0
				position = start_pos
				run = data[Global.sec_playing][Global.track_playing]
				#position.y += 512
#				vel = Vector2.ZERO
				dir = start_dir
				rotation = dir.angle()
				print(type)
#				rotation_vel = 0
#				timer = 0
#				physics = false
#				last_cp_pos = Vector2.ZERO
#				last_cp_dir = start_dir
#				local_cps = 0
#				lap = 1
#				$Start.start()
#		if(is_trying_to_move):
#			friction = 0.015
#		else:
#			friction = 0.005
#		if turning:
#			friction += 0.0005
#		if(boost_counter > 0):
#			vel += Vector2.UP.rotated(PI * boost_dir/180) * boost_vel
#		if(road_counter > 0):
#			traction_type = "road"
#		elif (dirt_counter > 0): 
#			traction_type = "dirt"
#			friction = 0.012
#		else:
#			traction_type = "off_road"
#			friction = 0.02
#
#		rotation_vel *= (1.0 - rot_friction)
#
#		if abs(rotation_vel) < 0.01 or vel_speed < 20 or vel * Vector2.UP.rotated(dir.angle()) < Vector2.ZERO or collision or traction_type == "off_road":
#			drifting = false
#
#		if drifting:
#			drift = 0.5
#			friction = 0.03
#			rotation_vel += drift_turn_speed
#			traction_type = "drift"
#		else:
#			drift = 0
#
#	#	print(Vector2(abs(vel.x), abs(vel.y)))
#	#	if abs(vel.x) > abs(vel.y):
#	#		friction = 0.0225
#
#		#$Label.text = Global.checkpoints_left as String
#		traction = traction_types[traction_type]
#
#		dir = dir.rotated(rotation_vel)
#
#		vel = vel.rotated(rotation_vel * traction * (1.0 - drift)) 
#
#
#		vel *= (1.0 - friction)
#		if not physics and not finishing:
#			dir = Vector2.RIGHT
#			position = start_pos
#		elif physics:
#			collision = move_and_collide(vel * delta)
#			timer += round(delta * 1000)/1000
#			rotation = dir.angle()
#
#		if(collision and just_had_collision):
#			can_hit_wall = false
#			vel = Vector2.ZERO
#			$HitWall.stop()
#		elif (not collision and $HitWall.time_left == 0 and not just_went):
#			$HitWall.start()
#		#print($HitWall.time_left)
#		if collision and can_hit_wall:
#	#		rotation_vel += 0.1 * vel.length() * 0.002 * collision.normal.dot(vel.normalized())
#			var coll_angle = collision.get_angle(dir.normalized()) if collision.get_angle(dir.normalized()) <= PI/2 else collision.get_angle(dir.normalized()) - PI
#			if(abs(coll_angle) <= PI/4.75):
#				rotation_vel += coll_angle/3
#	#		elif(collision.get_angle(vel) > PI/6 and collision.get_angle(vel.normalized()) <= PI/4):
#	#			rotation_vel += PI/2
#			else:
#				rotation_vel += -(PI/2 * sign(coll_angle) - coll_angle)/4
#			can_hit_wall = false
#			just_had_collision = true
#			just_went = false
#			vel *= lerp(1, 0.75, abs(coll_angle / TAU) * 4)
		just_changed = false
		#Input.action_release("restart")
#
#
func _on_HitWall_timeout():
	pass
#	can_hit_wall = true
#	just_had_collision = false
#	just_went = true
#	print("running")
#
func _on_Area2D_area_entered(area):
	pass
#	var parent = area.get_parent()
#	if (parent.is_in_group("Road")):
#		road_counter += 1
#	if (parent.is_in_group("Dirt")):
#		dirt_counter += 1
#	if (parent.is_in_group("Checkpoint") and not parent.gotten):
#		var block = parent.get_parent()
#		last_cp_pos = block.position
#		#last_cp_pos.y += 512
#		last_cp_dir = Vector2.RIGHT.rotated(block.rotation_degrees * PI/180)
#		local_cps += 1
#	if ((parent.is_in_group("Finish") or (parent.is_in_group("Start") and lap == 3)) and Global.total_checkpoints - local_cps == 0):
#		print("ghost finish")
#		local_cps = 0
#		physics = false
#		finishing = true
#		input_on = 0
#	elif parent.is_in_group("Start") and Global.total_checkpoints - local_cps == 0:
#		local_cps = 0
#		last_cp_pos = start_pos
#		last_cp_dir = Vector2.RIGHT
#		lap += 1
#
#	if area.is_in_group("Boost Panels"):
#		boost_counter += 1
#		boost_dir = area.rotation_degrees
func _on_Area2D_area_exited(area):
	pass
#	var parent = area.get_parent()
#	if (parent.is_in_group("Road")):
#		road_counter -= 1
#	if (parent.is_in_group("Dirt")):
#		dirt_counter -= 1
#	if area.is_in_group("Boost Panels"):
#		boost_counter -= 1
#
func _on_Start_timeout():
	input_on = 0
	position = start_pos
	#position.y += 512
	dir = start_dir

