extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ability_list = ["Dash","Fireball","IceShards","PillarOfFlame","Replenish","SummonBoulder","GraspingVines","PiercingLight", "DazzlingLight", "GalefulStorm"]
var next_client = null
var next_packs = []
var next_pack_ready = false
var ready_for_pack = true
var ready_amount = 0

func _ready():
	Network.client_abilities=[]
	generate_pack()

func generate_pack():
	$AbilityList.clear()
	var pack = []
	for i in 4:
		randomize()
		ability_list.shuffle()
		var ability = ability_list.pop_back()
		pack.append(ability)
	load_pack(pack)

func load_pack(pack):
	$AbilityList.clear()
	for ability in pack:
		$AbilityList.add_item(ability,load("res://Images/Abilities/Icons/"+ability+".png"))
	ready_for_pack = false
	if not next_packs.size():
		next_pack_ready = false

func get_next_pack():
	if next_pack_ready && ready_for_pack:
		load_pack(next_packs.pop_front())

remotesync func set_next_pack(pack, client):
	if Network.client_id == client:
		next_packs.append(pack)
		next_pack_ready = true
		get_next_pack()

func _on_AbilityList_item_activated(index):
	Network.client_abilities.append($AbilityList.get_item_text(index))
	$AbilityList.remove_item(index)
	if Network.client_abilities.size()==3:
		$AbilityList.clear()
		rpc("set_ready_status", Network.client_id)
	else:
		var next_pack = []
		for i in $AbilityList.get_item_count():
			next_pack.append($AbilityList.get_item_text(i))
		if next_client == null:
			var target_id = 1
			for id in Network.peer_ids:
				if Network.client_id < id:
					if id < target_id || target_id == 1:
						target_id = id
			next_client = target_id
		rpc("set_next_pack",next_pack, next_client)
		ready_for_pack = true
		$AbilityList.clear()
		get_next_pack()

remotesync func set_ready_status(id):
	if Network.is_host:
		if ready_amount==Network.peer_ids.size():
			rpc("start_game")	
		ready_amount+=1
			
remotesync func start_game():
	get_tree().change_scene("res://Scenes/Game.tscn")
