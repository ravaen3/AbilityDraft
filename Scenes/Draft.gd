extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ability_list = ["Dash","Fireball","IceShards","PillarOfFlame","Replenish","SummonBoulder"]

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.client_abilities=[]
	generate_pack()
	pass # Replace with function body.
func generate_pack():
	$AbilityList.clear()
	for i in 4:
		randomize()
		var ability = ability_list[randi()% ability_list.size()]
		$AbilityList.add_item(ability,load("res://Images/Abilities/Icons/"+ability+".png"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AbilityList_item_activated(index):
	Network.client_abilities.append($AbilityList.get_item_text(index))
	if Network.client_abilities.size()==3:
		$AbilityList.clear()
		if Network.is_host:
			rpc("start_game")
	else:
		generate_pack()
		
remotesync func start_game():
	get_tree().change_scene("res://Scenes/Game.tscn")
