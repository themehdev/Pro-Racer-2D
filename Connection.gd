extends Node2D

var status = "connecting"

func _ready():
	NetworkManager.start_connecting()
	NetworkManager._client.connect("connection_established", self, "connected")
	NetworkManager.connect("start", self, "start_game")

func connected(_proto):
	status = "waiting"
	$Label.text = "Waiting for players..."
	NetworkManager.send_msg({"ready": true})

func start_game():
	Global.opp_type = "live"
	get_tree().change_scene("res://Game.tscn")
	queue_free()

func _on_Button_pressed():
	get_tree().change_scene("res://Menus/Track Menu.tscn")
	queue_free()
