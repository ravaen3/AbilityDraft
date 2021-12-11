extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Network.set_ids()
	create_players()
	pass # Replace with function body.

func create_players():
	for id in Network.peer_ids:
		create_player(id)
	create_player(Network.client_id)
	
func create_player(id):
	var player = preload("res://Scenes/Player.tscn").instance()
	add_child(player)
	player.initialize(id)
	# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
