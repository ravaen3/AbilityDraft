extends Node2D

func _ready():
	Network.set_ids()
	create_players()

func create_players():
	for id in Network.peer_ids:
		create_player(id)
	create_player(Network.client_id)

func create_player(id):
	var player = preload("res://Scenes/Player.tscn").instance()
	add_child(player)
	player.initialize(id)
