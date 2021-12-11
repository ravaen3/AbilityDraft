extends Node2D


var is_master = false
var cooldown = 1
var on_cooldown = false
export var ability_slot = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("ability", self, "activate")

func activate(slot):
	if slot == ability_slot:
		if on_cooldown == false:
			on_cooldown = true
			rotation=0
			rotation=get_angle_to(get_global_mouse_position())
			rpc("spawn_projectile",$Emitter.global_position,rotation)
			yield(get_tree().create_timer(cooldown), "timeout")
			on_cooldown = false

remotesync func spawn_projectile(pos, rot):
	var projectile = preload("res://Scenes/Abilities/Projectiles/Fireball.tscn").instance()
	projectile.global_position=pos
	projectile.rotation=rot
	get_tree().get_root().add_child(projectile)
	

func _process(delta):	
	pass
