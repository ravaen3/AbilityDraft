extends Area2D
export var projectile_speed = 0
export var speed_increment = 0.00
export var damage = 0
export var damage_increment = 0.00
export (Array, String, "stunned", "slowed", "silenced", "rooted") var status_effect = []
export (Array, float) var duration = []

var velocity = Vector2(0,0)



func _ready():
	projectile_speed=projectile_speed
	velocity.x=projectile_speed
	velocity=velocity.rotated(rotation)
	yield(get_tree().create_timer(60), "timeout")
	queue_free()

func _process(delta):
	velocity = velocity*(1+(speed_increment*delta))
	position+=velocity*delta
	damage = damage*(1+(damage_increment*delta))
	
	


func _on_body_entered(body):
	if Network.is_host:
		if body.is_in_group("Player"):
			body.rpc("update_health",-damage)
			var i = 0
			for effect in status_effect:
				if duration[i]:
					body.rpc("set_status_effect", duration[i])
				++i
	queue_free()
