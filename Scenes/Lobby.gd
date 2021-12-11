extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ready_amount = 0
var ready = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if Network.is_host:
		$Start.disabled=false
	Network.set_ids()
	rpc("update_ready_status")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

remotesync func update_ready_status():
	Network.set_ids()
	$ReadyStatus.text="Ready: "+str(ready_amount)+"/"+str(Network.peer_ids.size()+1)
	
func _on_Ready_pressed():
	ready = true
	rpc("update_ready_status", Network.client_id)
	pass # Replace with function body.


func _on_Start_pressed():
	rpc("start_game")

remotesync func start_game():
	get_tree().change_scene("res://Scenes/Game.tscn")
