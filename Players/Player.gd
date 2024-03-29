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
var b_accel = 10
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
var check_last_time = 0
var drift_last_time = 0

onready var start_pos = Vector2.ZERO
onready var start_dir = Vector2.RIGHT
onready var last_cp_pos = start_pos
onready var last_cp_dir = Vector2.RIGHT

var cp_pos_last


# Called when the node enters the scene tree for the first time.
func _ready():
	position = start_pos
	set_col()
	set_volume()
	if Global.opp_type == "live":
		NetworkManager.connect("closed", self, "closed_connection")
		#NetworkManager.connect("synced", self, "synced")
		#NetworkManager.send_direct_msg({"start": "u can start already"})
		Global.live_races += 1
	#else: 
	$Start.start()

var can_hit_wall = true

var traction_types = {
	"road": 0.9,
	"dirt": 0.45,
	"drift": 0.15,
	"off_road": 0.25
}

func set_col():
	var col = Color8(Global.colR, Global.colG, Global.colB)
	$Graphics/ColorRect.color = col
	$Graphics/ColorRect2.color = col
	$Graphics/ColorRect3.color = col
	$Graphics/ColorRect4.color = col
	$Graphics/ColorRect5.color = col
	$Graphics/ColorRect6.color = col
	$Graphics/Polygon2D.color = col

func set_volume():
	$Checkpoint.volume_db = Global.FXsound
	$Drift.volume_db = Global.FXsound
	$Crash.volume_db = Global.FXsound
	$Start2.volume_db = Global.FXsound

func restart():
	$Start2.play()
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
	$"%Time".text = ""
	$"%Splits".text = ""
	timer = 0
	physics = false
	last_cp_pos = start_pos
	last_cp_dir = start_dir
	lap = 1
	finishing = false
	$Start.start()
	print("restarting")
	$"%Finish Menu".hide()

func set_start(args):
	start_pos = args[0]
	last_cp_pos = args[0]
	start_dir = Vector2.RIGHT.rotated(args[1])
	last_cp_dir = Vector2.RIGHT.rotated(args[1])
	run["inputs"].append({"pos": start_pos, "dir": start_dir})
	#print(args[1])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if last_cp_pos != cp_pos_last:
		print(last_cp_pos)
	cp_pos_last = last_cp_pos
	if(Global.opp_type == "live" and Global.can_start and $Start.time_left == 0):
		physics = true
		Global.can_start = false
	$"No Zoom/CanvasLayer/Popup/HBoxContainer/Menu".disabled = Global.track_playing == -1
	has_popup = $"%Popup".visible
	Global.player = self
	#var actions_changed = Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_up") or Input.is_action_just_pressed("respawn")
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[1])
	add_collision_exception_with(get_tree().get_nodes_in_group("Player")[0])
	turning = false
	var vel_speed = abs(vel.x) + abs(vel.y)
	var acc_vel = vel.rotated(-dir.angle())
	if sign(acc_vel.y) < 0:
		b_accel = 15
	else:
		b_accel = 10
	$"%Start Text".text = ceil($Start.time_left) as String if $Start.time_left != 0 else "Go!"
	#print(vel_speed)
	if timer > 1:
		$Start2.stop()
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
	if(Input.is_action_just_pressed("ui_right")):
		$AnimationPlayer.play("Turn_right")
	if(Input.is_action_just_pressed("ui_left")):
		$AnimationPlayer.play("Turn_left")
	if Input.is_action_just_released("ui_left"):
		$AnimationPlayer.play_backwards("Turn_left")
	if Input.is_action_just_released("ui_right"):
		$AnimationPlayer.play_backwards("Turn_right")
	
	if drift_last_time > $Drift.get_playback_position():
		$Drift.stop()
	if check_last_time > $Checkpoint.get_playback_position():
		$Checkpoint.stop()
	if $Crash.get_playback_position() > 0.4:
		$Crash.stop()
	drift_last_time = $Drift.get_playback_position()
	check_last_time = $Checkpoint.get_playback_position()
	
	
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
			$Drift.play()
		is_trying_to_move = true
	if Input.is_action_pressed("respawn") and (last_cp_pos != start_pos or lap != 1) and physics:
		position = last_cp_pos
		vel = Vector2.ZERO
		rotation_vel = 0
		dir = last_cp_dir
	if Input.is_action_just_pressed("pause"):
		$"%Popup".popup_centered()
		if Global.opp_type != "live":
			physics = false
		if $Start.time_left != 0 and Global.opp_type != "live":
			$Start.wait_time = $Start.time_left
			$Start.stop()
			$Start2.stop()
			start_stopped = true
	#print(Input.is_action_pressed("restart"))
	if ((Input.is_action_just_pressed("restart") or (Input.is_action_pressed("respawn") and last_cp_pos == start_pos and lap == 1)) and not $"%Popup".visible) and Global.opp_type != "live":
#		print(last_cp_pos)
#		print(start_pos)
		restart()
	if(boost_counter > 0):
		vel += Vector2.UP.rotated(PI * boost_dir/180) * boost_vel
	
	if(road_counter > 0):
		traction_type = "road"
		friction = 0.01
		if abs(acc_vel.x) > abs(acc_vel.y):
			friction += 0.0175
	elif (dirt_counter > 0): 
		traction_type = "dirt"
		friction = 0.01075
		if abs(acc_vel.x) > abs(acc_vel.y):
			friction += 0.00825
	else:
		traction_type = "off_road"
		friction = 0.0175
	if turning:
		friction += 0.001
	rotation_vel *= (1.0 - rot_friction)
	
	if not turning or -acc_vel.y + abs(acc_vel.x) < 100 or collision or traction_type == "off_road" or abs(rotation_vel) < 0.005:
		drifting = false
		$Drift.stop()
	
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
		$"%Time".text = "Time: " + gen_time(timer)
		rotation = dir.angle()
		run["inputs"].append({"pos": Global.vec2_to_xy(position), "dir" : rotation})
		if Global.opp_type == "live":
			NetworkManager.send_direct_msg({"input": {"pos": Global.vec2_to_xy(position), "dir" : rotation}})
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
		$Crash.play()
		var coll_angle = collision.get_angle(dir.normalized()) if collision.get_angle(dir.normalized()) <= PI/2 else collision.get_angle(dir.normalized()) - PI
		var boing_angle = collision.get_angle(vel.normalized()) if collision.get_angle(vel.normalized()) <= PI/2 else collision.get_angle(vel.normalized()) - PI
		#print(-abs(boing_angle/(PI/2)) + 1)
		if(abs(coll_angle) <= PI/4.75):
			#print((collision.get_position() - position).rotated(dir.angle()).y)
			rotation_vel += coll_angle/2 * -sign((collision.get_position() - position).rotated(-dir.angle()).y)
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
	$Camera2D.zoom = Vector2(1.75 + smooth_zoom * 1.5, 1.75 + smooth_zoom * 1.5)
	if smooth_zoom >= 1:
		$Camera2D.zoom = Vector2(3.25, 3.25)
	$"%No Zoom".scale = $Camera2D.zoom
	#Input.action_release("restart")
	moving_forward = true

func gen_time(time):
	return  (floor(time/60) if time >= 0 else ceil(time/60)) as String + ":" + (abs(fmod(time, 60.0)) as String if fmod(time, 60.0) > 10 else ("0" + abs(fmod(time, 60.0)) as String))

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
		$Checkpoint.play()
		run["splits"].append(timer)
		var block = parent.get_parent()
		parent.gotten = true
		last_cp_pos = block.position
		#last_cp_pos.y += 512
#		last_cp_pos.y -= 206
		last_cp_dir = Vector2.RIGHT.rotated(block.rotation_degrees * PI/180)
		$"%Splits".text = gen_time(timer)
		if Global.best_run["time"] != 0:
			#print(timer - Global.best_run["splits"][split_on])
			$"%Splits".text += "\n\n" + (gen_time(timer - Global.best_run["splits"][split_on]) if (timer - Global.best_run["splits"][split_on]) <= 0 else "+" + gen_time(timer - Global.best_run["splits"][split_on]))
		Global.checkpoints_left -= 1
		split_on += 1
		if Global.opp_type == "live":
			NetworkManager.send_direct_msg({"split": timer})
#			#print(timer)
#		print(Global.live_splits["split_on"])
#		print(split_on)
		if split_on <= Global.live_splits["split_on"] and Global.opp_type == "live":
			$"%Splits".text += "\n\n2nd: " + (gen_time(timer - Global.live_splits["splits"][split_on - 1]) if (timer - Global.live_splits["splits"][split_on - 1]) <= 0 else "+" + gen_time(timer - Global.live_splits["splits"][split_on - 1]))
		elif Global.opp_type == "live":
			$"%Splits".text += "\n\n1st!"
	if ((parent.is_in_group("Finish") or (parent.is_in_group("Start") and lap == 3)) and Global.checkpoints_left == 0):
		$Checkpoint.play()
		run["inputs"].append({"pos": Global.vec2_to_xy(position), "dir" : rotation})
		#run["input_splits"].append(timer)
		$"%Splits".text = "Finish!: " + gen_time(timer)
		if Global.best_run["time"] != 0:
			$"%Splits".text += "\n\n" + (gen_time(timer - Global.best_run["time"]) if (timer - Global.best_run["time"]) <= 0 else "+" + gen_time(timer - Global.best_run["time"]))
		if Global.opp_type == "live" and Global.live_splits["time"] != 0:
			$"%Splits".text += "\n\n2nd: " + (gen_time(timer - Global.live_splits["time"]) if (timer - Global.live_splits["time"]) <= 0 else "+" + gen_time(timer - Global.live_splits["time"]))
			#Global.live_races += 1
		elif Global.opp_type == "live":
			$"%Splits".text += "\n\n1st!"
			#Global.live_races += 1
			Global.live_wins += 1
			Global.save_to_file({"live_races": Global.live_races, "live_wins": Global.live_wins}, "live_stats")
		run["time"] = timer
		if timer < Global.pb_times[Global.sec_playing][Global.track_playing]["time"] or Global.pb_times[Global.sec_playing][Global.track_playing]["time"] == 0:
			Global.pb_times[Global.sec_playing][Global.track_playing] = run
			#print(Global.track_playing)
		physics = false
		finishing = true
		if Global.opp_type == "live":
			NetworkManager.send_direct_msg({"time": timer})
		Global.save_to_file(Global.pb_times, "pb_times")
		Global.sec_has = 1
		for i in Global.num_tracks:
			if Global.pb_times["Beginner"][i]["time"] < Global.official_times["Beginner"][i]["time"] and Global.pb_times["Beginner"][i]["time"] != 0:
				Global.sec_has += 0.2
				if Global.pb_times["Beginner"][i]["time"] < Global.world_times["Beginner"][i]["time"]:
					Global._make_post_request(Global.URL_WORLD + "/Beginner/" + i as String + ".json", Global.pb_times["Beginner"][i])
					Global.world_times["Beginner"][i] = Global.pb_times["Beginner"][i]
				#print(Global.sec_has)
			if Global.pb_times["Intermediate"][i]["time"] < Global.official_times["Intermediate"][i]["time"] and Global.pb_times["Intermediate"][i]["time"] != 0:
				Global.sec_has += 0.2
				if Global.pb_times["Intermediate"][i]["time"] < Global.world_times["Intermediate"][i]["time"]:
					Global._make_post_request(Global.URL_WORLD + "/Intermediate/" + i as String + ".json", Global.pb_times["Intermediate"][i])
					Global.world_times["Intermediate"][i] = Global.pb_times["Intermediate"][i]
			if Global.pb_times["Accomplished"][i]["time"] < Global.official_times["Accomplished"][i]["time"] and Global.pb_times["Accomplished"][i]["time"] != 0:
				Global.sec_has += 0.2
				if Global.pb_times["Accomplished"][i]["time"] < Global.world_times["Accomplished"][i]["time"]:
					Global._make_post_request(Global.URL_WORLD + "/Accomplished/" + i as String + ".json", Global.pb_times["Accomplished"][i])
					Global.world_times["Accomplished"][i] = Global.pb_times["Accomplished"][i]
			if Global.pb_times["Advanced"][i]["time"] < Global.official_times["Advanced"][i]["time"] and Global.pb_times["Advanced"][i]["time"] != 0:
				Global.sec_has += 0.2
				if Global.pb_times["Advanced"][i]["time"] < Global.world_times["Advanced"][i]["time"]:
					Global._make_post_request(Global.URL_WORLD + "/Advanced/" + i as String + ".json", Global.pb_times["Advanced"][i])
					Global.world_times["Advanced"][i] = Global.pb_times["Advanced"][i]
			if Global.pb_times["Professional"][i]["time"] < Global.official_times["Professional"][i]["time"] and Global.pb_times["Professional"][i]["time"] != 0:
				Global.sec_has += 0.2
				if Global.pb_times["Professional"][i]["time"] < Global.world_times["Professional"][i]["time"]:
					Global._make_post_request(Global.URL_WORLD + "/Professional/" + i as String + ".json", Global.pb_times["Professional"][i])
					Global.world_times["Professional"][i] = Global.pb_times["Professional"][i]
		$"%Finish Menu".popup()
		
		#print(run)
		
	elif parent.is_in_group("Start") and Global.checkpoints_left == 0 and Global.track_has_finish == false:
		$Checkpoint.play()
		run["splits"].append(timer)
		get_tree().call_group("Checkpoint", "reset")
		last_cp_pos = start_pos
		last_cp_dir = start_dir
		$"%Splits".text = gen_time(timer)
		if Global.best_run["time"] != 0:
			$"%Splits".text += "\n\n" + (gen_time(timer - Global.best_run["splits"][split_on]) if (timer - Global.best_run["splits"][split_on]) <= 0 else "+" + gen_time(timer - Global.best_run["splits"][split_on]))
		$"%Splits".text += "\n\n" + ("Last lap!" if 3 - lap == 1 else (3 - lap) as String + " laps to go!")
		lap += 1
		split_on += 1
		if Global.opp_type == "live":
			NetworkManager.send_direct_msg({"split": timer})
		if split_on <= Global.live_splits["split_on"] and Global.opp_type == "live":
			$"%Splits".text += "\n\n2nd: " + (gen_time(timer - Global.live_splits["splits"][split_on - 1]) if (timer - Global.live_splits["splits"][split_on - 1]) <= 0 else "+" + gen_time(timer - Global.live_splits["splits"][split_on - 1]))
		elif Global.opp_type == "live":
			$"%Splits".text += "\n\n1st!"
	
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
	if Global.opp_type == "live":
		print("sent")
		NetworkManager.send_direct_msg({"start": "u can start already"})
	physics = Global.can_start or Global.opp_type != "live"
	print(Global.can_start as String)
	print(Global.opp_type != "live" as String)
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
	
func synced():
	Global.can_start = true
	

func _on_Menu_pressed():
	if Global.opp_type == "live":
		NetworkManager._client.disconnect_from_host()
	get_tree().change_scene("res://Menus/Menu.tscn")
	$"%Popup".hide()
	get_parent().queue_free()

func closed_connection():
	if(Global.live_splits["time"] == 0 and not finishing):
		#Global.live_races += 1
		Global.live_wins += 1
		Global.save_to_file({"live_races": Global.live_races, "live_wins": Global.live_wins}, "live_stats")
		get_tree().change_scene("res://Menus/Track Menu.tscn")
		get_parent().queue_free()

func _on_Resume_pressed():
	if not finishing and not start_stopped:
		physics = true
		#print("yay")
	if start_stopped:
		$Start.start()
		$Start2.play(3 - $Start.time_left)
		start_stopped = false
	if finishing == true:
		restart()
	pop_needs_hiding = true

func _on_Player_tree_exited():
	Global.player = {"physics" : false, "finishing": false, "timer": 0}

func _on_Finish_Menu_restart():
	print("Happening")
	restart()

func _on_Finish_Menu_exiting():
	get_parent().queue_free()

func _on_Crash_finished():
	$Crash.stop()

func _on_Checkpoint_finished():
	$Checkpoint.stop()

func _on_Drift_finished():
	$Drift.stop()

func _on_Start2_finished():
	$Start2.stop()
