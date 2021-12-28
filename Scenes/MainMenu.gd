extends Control

func _ready():
	get_tree().connect("connected_to_server", self, "connected")

func connected():
	print("Connected!")
	get_tree().change_scene("res://Scenes/Lobby.tscn")
	
	
func _on_JoinServer_pressed():
	var FullIP=$IpInput.text.split(":")
	if FullIP[0].is_valid_ip_address():
		Network.server_ip = FullIP[0]
		if typeof(FullIP[1])== TYPE_INT:
			Network.server_port = FullIP[1]
	Network.join_server()


func _on_StartServer_pressed():
	Network.start_server()
	get_tree().change_scene("res://Scenes/Lobby.tscn")


func _on_NameInput_text_changed(p_name):
	if p_name.is_valid_identifier():
		Network.client_name = p_name
