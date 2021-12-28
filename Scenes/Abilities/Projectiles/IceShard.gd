extends Area2D


# Declare member variables here. Examples:
var ProjectileSpeed = 1200
var velocity = Vector2(0,0)
var damage = 20
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x=ProjectileSpeed
	velocity=velocity.rotated(rotation)
	yield(get_tree().create_timer(60), "timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+=velocity*delta


func _on_Fireball_body_entered(body):
	if Network.is_host:
		body.rpc("update_health",-damage)
		body.rpc("set_status_effect", "slowed", 2)
	queue_free()
	pass # Replace with function body.
