extends Area2D


# Declare member variables here. Examples:
var ProjectileSpeed = 1000
var velocity = Vector2(0,0)
var damage = 20
var root_duration = 1
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x=ProjectileSpeed
	velocity=velocity.rotated(rotation)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=velocity*delta

func _on_Vines_body_entered(body):
	if Network.is_host:
		body.rpc("update_health",-damage)
		body.rpc("set_status_effect", "rooted", root_duration)
	queue_free()
