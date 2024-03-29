extends Area2D


# Declare member variables here. Examples:
var projectile_speed = 500
var velocity = Vector2(0,0)
var damage = 40
var stun_duration = 0.3
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x=projectile_speed
	velocity=velocity.rotated(rotation)
	yield(get_tree().create_timer(2), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity=velocity*1.02
	position+=velocity*delta
	stun_duration+=delta

func _on_Boulder_body_entered(body):
	if Network.is_host:
		body.rpc("update_health",-damage)
		body.rpc("set_status_effect", "stunned", stun_duration)
	queue_free()
