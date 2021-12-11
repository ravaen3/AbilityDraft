extends Node2D


var is_master = false
var cooldown = 3
var on_cooldown = false
export var ability_slot = 0

func _ready():
	get_parent().connect("ability", self, "activate")

func activate(slot):
	if slot == ability_slot:
		if on_cooldown == false:
			on_cooldown = true
			rpc("spawn_projectile",get_global_mouse_position())
			yield(get_tree().create_timer(cooldown), "timeout")
			on_cooldown = false

remotesync func spawn_projectile(pos):
	var projectile = preload("res://Scenes/Abilities/Projectiles/PillarOfFlame.tscn").instance()
	projectile.global_position=pos
	get_tree().get_root().add_child(projectile)
