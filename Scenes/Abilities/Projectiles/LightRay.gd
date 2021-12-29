extends Area2D


# Declare member variables here. Examples:
var projectile_speed = 2000
var velocity = Vector2(0,0)
var damage = 10
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x=projectile_speed
	velocity=velocity.rotated(rotation)
	yield(get_tree().create_timer(60), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=velocity*delta


func _on_LightRay_body_entered(body):
	if Network.is_host:
		body.rpc("update_health",-damage)
	queue_free()
