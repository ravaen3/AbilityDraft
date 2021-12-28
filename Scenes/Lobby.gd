extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ready_amount = 0
var ready = false
var player_amount = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Network.set_ids()
	rpc("update_ready_status", 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

remotesync func update_ready_status(change):
	Network.set_ids()
	ready_amount+=change
	player_amount = Network.peer_ids.size()+1
	$ReadyStatus.text="Ready: "+str(ready_amount)+"/"+str(player_amount)
	if Network.is_host && ready_amount>=player_amount:
		$Start.disabled=false
	else:
		$Start.disabled=true
	
func _on_Ready_pressed():
	if ready == false:
		ready = true
		rpc("update_ready_status", 1)
	else:
		ready = false
		rpc("update_ready_status", -1)


func _on_Start_pressed():
	rpc("start_draft")

remotesync func start_draft():
	get_tree().change_scene("res://Scenes/Draft.tscn")
