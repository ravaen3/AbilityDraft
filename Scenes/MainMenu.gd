extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server", self, "connected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func connected():
	print("Connected!")
	get_tree().change_scene("res://Scenes/Lobby.tscn")
	
	
func _on_JoinServer_pressed():
	var FullIP=$IpInput.text.split(":")
	if FullIP[0].is_valid_ip_address():
		Network.server_ip = FullIP[0]
		Network.server_port = FullIP[1]
	Network.join_server()
	pass # Replace with function body.


func _on_StartServer_pressed():
	Network.start_server()
	get_tree().change_scene("res://Scenes/Lobby.tscn")
	pass # Replace with function body.


func _on_NameInput_text_changed(p_name):
	if p_name.is_valid_identifier():
		Network.client_name = p_name
