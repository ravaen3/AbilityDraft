extends Area2D


# Declare member variables here. Examples:
var projectile_speed = 1500
var velocity = Vector2(0,0)
var damage = 40
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


func _on_Fireball_body_entered(body):
	if Network.is_host:
		if body.is_in_group("Player"):
			body.rpc("update_health",-damage)
	queue_free()
	pass # Replace with function body.
