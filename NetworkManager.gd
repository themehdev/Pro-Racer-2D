extends Node

var _client = WebSocketClient.new()
var id
var opponent_id = null
var players = []
export var websocket_url = "wss://assorted-glass-behavior.glitch.me/"
var connected = false
var sync_timer = 0
var last_data = {}

signal split(split)
signal start

func _init():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_on_error")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	

func start_connecting():
	print("Connecting...")

	#glitch.com requires these headers to be sent to connect through websockets.
	var custom_headers = []
	if not OS.has_feature("HTML5"):
		custom_headers = PoolStringArray([
			"Connection: keep-alive",
			"User-Agent: Websocket Demo",
		])
	var err = _client.connect_to_url(websocket_url, PoolStringArray([]), false, custom_headers)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Disconnected!")
	connected = false

func _connected(_proto):
	print("Connected!")
	connected = true
	send_msg({"game": "Pro Racer 2D " + Global.sec_playing + " " + Global.track_playing as String, "ready": false})

func _on_error():
	print("Connection error!")

var data
var data_was_split = false

func _on_data():
	var msg = _client.get_peer(1).get_packet().get_string_from_utf8()
	data = JSON.parse(msg).result
	if "ids" in data:
		opponent_id = data["ids"][0]
		emit_signal("start")
		return
	if data.hash() == last_data.hash():
		return
	last_data = data
	if "split" in data:
		print(data)
		print("yay")
		Global.live_splits["split_on"] += 1
		Global.live_splits["splits"].append(data["split"])
	if "time" in data:
		Global.live_splits["time"] = data["time"]
		
		#print(Global.live_splits)
#
#func get_data():
#	return data


func send_msg(dict):
	if connected:
		var parsed = JSON.print(dict)
		_client.get_peer(1).put_packet(parsed.to_utf8())

func send_direct_msg(msg):
	if "split" in msg:
		print("sending split")
	if opponent_id:
		send_msg({
			"id": opponent_id,
			"message": msg,
			"is_direct_msg": true
		})

func _process(delta):
	_client.poll()
