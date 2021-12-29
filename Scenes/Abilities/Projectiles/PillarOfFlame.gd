extends Area2D


var total_travel_time = 0.7
var travel_time = 0
var duration = 0.3
var damage = 35
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		pass
	elif travel_time>=total_travel_time:
		$Collision.disabled=false
		active = true
		yield(get_tree().create_timer(duration), "timeout")
		queue_free()
	else:
		travel_time+=delta
	$tIndicator.scale=Vector2(travel_time/total_travel_time,travel_time/total_travel_time)


func _on_PillarOfFlame_body_entered(body):
	if Network.is_host:
		body.rpc("update_health",-damage)
	queue_free()
