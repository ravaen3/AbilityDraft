extends Node

const DEFAULT_PORT = 32064
const DEFAULT_IP = "127.0.0.1"
const MAX_CLIENTS = 7

var server_ip = DEFAULT_IP
var server_port = DEFAULT_PORT
var is_host = false
var client_id = null
var client_name = "Guest"
var client_abilities = ["Fireball","IceShards","PillarOfFlame"]
var peer_ids = []

func start_server():
	is_host = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().network_peer=peer
	
func join_server():
	var peer = NetworkedMultiplayerENet.new()
	if server_ip.is_valid_ip_address():
		peer.create_client(server_ip, DEFAULT_PORT)
	else:	
		peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().network_peer=peer

func set_ids():
	client_id = get_tree().get_network_unique_id()
	peer_ids = get_tree().get_network_connected_peers()
