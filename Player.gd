extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var boost_vel = 75
var lap = 1
var split_on = 0
var smooth_zoom = 0
var vel = Vector2(0, 0)
var dir = Vector2.RIGHT
var rotation_speed = 0.006
var rotation_vel = 0
var accel = 20
var b_accel = 17.5
var max_speed = 1800
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
var boost_counter = 0
var boost_dir = 0
var timer = 0
var just_had_collision = false
var just_went = true
var start = 3
var physics = false
var just_physics = false
var finishing = false
var pop_needs_hiding = false
var turning = false
var run = {"time": 0, "inputs": [], "splits": []}
var has_popup = false
var moving_forward = true
var start_stopped = false
onready var start_pos = Vector2.ZERO
onready var start_dir = Vector2.RIGHT
onready var last_cp_pos = start_pos
onready var last_cp_dir = Vector2.RIGHT



# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_pos

var can_hit_wall = true

var traction_types = {
	"road": 0.9,
	"dirt": 0.51,
	"drift": 0.15,
	"off_road": 0.25
}

func set_start(args):
	start_pos = args[0]
	last_cp_pos = args[0]
	start_dir = Vector2.RIGHT.rotated(args[1])
	last_cp_dir = Vector2.RIGHT.rotated(args[1])
	run["inputs"].append({"pos": start_pos, "dir": start_dir})
	#print(args[1])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	has_popup = $"%Popup".visible
	Global.player = self
	#var actions_changed = Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_up") or Input.is_action_just_pressed("respawn")
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[1])
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[0])
	turning = false
	var vel_speed = abs(vel.x) + abs(vel.y)
	var acc_vel = vel.rotated(-dir.angle())
	$"%Start Text".text = ceil($Start.time_left) as String if $Start.time_left != 0 else "Go!"
	#print(vel_speed)
	if timer > 1:
		$"%Start Text".visible = false
#	speed /= vel_speed/accel_hamper + 1
	
#	speed = clamp(max_speed, 0, speed)
	#print(Input.is_action_just_pressed("any_action") as String + Input.is_action_just_pressed("ui_left") as String)
	
	#
	#print((Input.is_action_just_pressed("any_action") or Input.is_action_just_released("any_action") or just_physics) and physics)
#	if (actions_changed or just_physics) and physics:
#		run["inputs"].append({"up": Input.is_action_pressed("ui_up"), "down": Input.is_action_pressed("ui_down"), "left": Input.is_action_pressed("ui_left"), "right": Input.is_action_pressed("ui_right"), "respawn": Input.is_action_just_pressed("respawn")})
#		run["input_splits"].append(timer)
	
#	if len(run["inputs"]) == 4:
#		pass
	
	#print(vel.rotated(dir.angle()))
	if vel.normalized() == Vector2.DOWN.rotated(dir.angle()):
		moving_forward = false
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		is_trying_to_move = false
	drift_turn_speed = 0
	if Input.is_action_pressed("ui_left"):
		drift_turn_speed = -0.005
		turning = true
		rotation_vel -= rotation_speed * abs(acc_vel.y)/vel_to_turn_divisor * -sign(vel.rotated(-dir.angle()).y)
	if Input.is_action_pressed("ui_right"):
		drift_turn_speed = 0.005
		turning = true
		rotation_vel += rotation_speed * abs(acc_vel.y)/vel_to_turn_divisor * -sign(vel.rotated(-dir.angle()).y)
	if Input.is_action_pressed("ui_up") and physics:
		vel += Vector2.UP.rotated(dir.angle()) * accel
		is_trying_to_move = true
	if Input.is_action_pressed("ui_down") and physics:
		vel += Vector2.DOWN.rotated(dir.angle()) * b_accel
		if vel.length_squared() > min_drift_speed * min_drift_speed and turning:
			drifting = true
		is_trying_to_move = true
	if Input.is_action_pressed("respawn") and (last_cp_pos != start_pos or lap != 1) and physics:
		position = last_cp_pos
		vel = Vector2.ZERO
		rotation_vel = 0
		dir = last_cp_dir
	if Input.is_action_just_pressed("pause"):
		$"%Popup".popup_centered()
		physics = false
		if $Start.time_left != 0:
			$Start.wait_time = $Start.time_left
			$Start.stop()
			start_stopped = true
	#print(Input.is_action_pressed("restart"))
	if Input.is_action_just_pressed("restart") or (Input.is_action_pressed("respawn") and last_cp_pos == start_pos and lap == 1):
		$"%Start Text".visible = true
		run = {"time": 0, "inputs": [{"pos": start_pos, "dir": start_dir.angle()}], "splits": []}
		get_tree().call_group("Checkpoint", "reset")
		position = start_pos
		#print("restart")
		vel = Vector2.ZERO
		dir = start_dir
		split_on = 0
		rotation = dir.angle()
		rotation_vel = 0
		$"%Label".text = ""
		$"%Label2".text = ""
		timer = 0
		physics = false
		last_cp_pos = start_pos
		last_cp_dir = start_dir
		lap = 1
		finishing = false
		$Start.start()
	if(boost_counter > 0):
		vel += Vector2.UP.rotated(PI * boost_dir/180) * boost_vel
	
	if(road_counter > 0):
		traction_type = "road"
		friction = 0.01
		if abs(acc_vel.x) > abs(acc_vel.y):
			friction += 0.0175
	elif (dirt_counter > 0): 
		traction_type = "dirt"
		friction = 0.011
		if abs(acc_vel.x) > abs(acc_vel.y):
			friction += 0.01
	else:
		traction_type = "off_road"
		friction = 0.0175
	if turning:
		friction += 0.001
	rotation_vel *= (1.0 - rot_friction)
	
	if not turning or -acc_vel.y + abs(acc_vel.x) < 20 or collision or traction_type == "off_road":
		drifting = false
	
	if drifting:
		drift = 0.5
		friction = 0.02 * (0.875 if road_counter == 0 and dirt_counter > 0 else 1)
		rotation_vel += drift_turn_speed
		traction_type = "drift"
	else:
		drift = 0
		
#	print(Vector2(abs(vel.x), abs(vel.y)))
#	if abs(vel.x) > abs(vel.y):
#		friction = 0.0225
	
	#$Label.text = Global.checkpoints_left as String
	traction = traction_types[traction_type]
	
	if has_popup:
		friction = 0
	
	vel *= (1.0 - friction)
	#print($"%Popup".visible)
	if not physics and not finishing and not $"%Popup".visible:
		dir = start_dir
		rotation = start_dir.angle()
		position = start_pos
	elif physics:
		$Start.wait_time = 3
		dir = dir.rotated(rotation_vel)
		vel = vel.rotated(rotation_vel * traction) #* 1.0 - drift
		collision = move_and_collide(vel * delta)
		timer += round(delta * 1000)/1000
		$"%Label2".text = "Time: " + timer as String
		rotation = dir.angle()
		run["inputs"].append({"pos": position, "dir" : rotation})
		#run["input_splits"].append(timer)
	if pop_needs_hiding:
		$"%Popup".hide()
		pop_needs_hiding = false
	
	
	
	if(collision and just_had_collision):
		can_hit_wall = false
		vel = Vector2.ZERO
		$HitWall.stop()
		#print("why")
	elif (not collision and $HitWall.time_left == 0 and not just_went):
		$HitWall.start()
	#print($HitWall.time_left)
	if collision and can_hit_wall:
#		rotation_vel += 0.1 * vel.length() * 0.002 * collision.normal.dot(vel.normalized())
		var coll_angle = collision.get_angle(dir.normalized()) if collision.get_angle(dir.normalized()) <= PI/2 else collision.get_angle(dir.normalized()) - PI
		var boing_angle = collision.get_angle(vel.normalized()) if collision.get_angle(vel.normalized()) <= PI/2 else collision.get_angle(vel.normalized()) - PI
		#print(-abs(boing_angle/(PI/2)) + 1)
		if(abs(coll_angle) <= PI/4.75):
			rotation_vel += coll_angle/2 * -sign(vel.rotated(-dir.angle()).y)
			vel = vel.bounce(collision.normal)
#		elif(collision.get_angle(vel) > PI/6 and collision.get_angle(vel.normalized()) <= PI/4):
#			rotation_vel += PI/2
		else:
			#rotation_vel += -(PI/2 * sign(coll_angle) - coll_angle)/4 * -sign(vel.rotated(-dir.angle()).y)
			vel = Vector2.ZERO
		can_hit_wall = false
		just_had_collision = true
		just_went = false
		#print(log(-0.15497))
		vel *= lerp(0.2, 0, -abs(boing_angle/(PI/2)) + 1)
	just_physics = false
	if smooth_zoom >= vel_speed/1900 + 0.025:
		smooth_zoom -= 0.025
	else :
		smooth_zoom = vel_speed/1900
	$Camera2D.zoom = Vector2(1.5 + smooth_zoom, 1.5 + smooth_zoom)
	if smooth_zoom >= 1:
		$Camera2D.zoom = Vector2(2.5, 2.5)
	$"%No Zoom".scale = $Camera2D.zoom
	Input.action_release("restart")
	moving_forward = true

func _on_HitWall_timeout():
	can_hit_wall = true
	just_had_collision = false
	just_went = true
	#print("running")

func _on_Area2D_area_entered(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter += 1
	if (parent.is_in_group("Dirt")):
		dirt_counter += 1
	if (parent.is_in_group("Checkpoint") and not parent.gotten):
		run["splits"].append(timer)
		var block = parent.get_parent()
		parent.gotten = true
		last_cp_pos = block.position
		#last_cp_pos.y += 512
#		last_cp_pos.y -= 206
		last_cp_dir = Vector2.RIGHT.rotated(block.rotation_degrees * PI/180)
		$"%Label".text = timer as String
		if Global.tracks[Global.track_playing]["best_run"]["time"] != 0:
			$"%Label".text += "\n" + ((timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) if (timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) <= 0 else "+" + (timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) as String) as String
		Global.checkpoints_left -= 1
		split_on += 1
	if ((parent.is_in_group("Finish") or (parent.is_in_group("Start") and lap == 3)) and Global.checkpoints_left == 0):
		run["inputs"].append({"pos": position, "dir" : rotation})
		#run["input_splits"].append(timer)
		$"%No Zoom/Label".text = "Finish!: " + timer as String
		if Global.tracks[Global.track_playing]["best_run"]["time"] != 0:
			$"%No Zoom/Label".text += "\n" + ((timer - Global.tracks[Global.track_playing]["best_run"]["time"]) if (timer - Global.tracks[Global.track_playing]["best_run"]["time"]) <= 0 else "+" + (timer - Global.tracks[Global.track_playing]["best_run"]["time"]) as String) as String
		run["time"] = timer
		if timer < Global.tracks[Global.track_playing]["best_run"]["time"] or Global.tracks[Global.track_playing]["best_run"]["time"] == 0:
			Global.tracks[Global.track_playing]["best_run"] = run
			#print(Global.track_playing)
		physics = false
		finishing = true
		#print(run)
		
	elif parent.is_in_group("Start") and Global.checkpoints_left == 0 and Global.track_has_finish == false:
		run["splits"].append(timer)
		get_tree().call_group("Checkpoint", "reset")
		last_cp_pos = start_pos
		last_cp_dir = start_dir
		$"%Label".text = timer as String
		if Global.tracks[Global.track_playing]["best_run"]["time"] != 0:
			$"%Label".text += "\n" + ((timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) if (timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) <= 0 else "+" + (timer - Global.tracks[Global.track_playing]["best_run"]["splits"][split_on]) as String) as String
		$"%Label".text += "\n" + ("Last lap!" if 3 - lap == 1 else (3 - lap) as String + " laps to go!")
		lap += 1
		split_on += 1
	
	if area.is_in_group("Boost Panels"):
		boost_counter += 1
		boost_dir = area.rotation_degrees
		

func _on_Area2D_area_exited(area):
	var parent = area.get_parent()
	if (parent.is_in_group("Road")):
		road_counter -= 1
	if (parent.is_in_group("Dirt")):
		dirt_counter -= 1
	if area.is_in_group("Boost Panels"):
		boost_counter -= 1

func _on_Start_timeout():
	physics = true
	finishing = false
	just_physics = true
	vel = Vector2.ZERO
	split_on = 0
	position = start_pos
	#position.y += 512
	dir = start_dir
	timer = 0
	rotation_vel = 0
	get_tree().call_group("Checkpoint", "reset")

func _on_Menu_pressed():
	get_tree().change_scene("res://Menu.tscn")
	$"%Popup".hide()
	get_parent().get_child(0).queue_free()
	get_parent().queue_free()

func _on_Resume_pressed():
	if not finishing and not start_stopped:
		physics = true
		#print("yay")
	if start_stopped:
		$Start.start()
		start_stopped = false
	pop_needs_hiding = true


func _on_Player_tree_exited():
	Global.player = {"has_popup" : false}
