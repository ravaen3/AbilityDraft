extends Node2D


var is_master = false
var cooldown = 3
var on_cooldown = false
var mana_cost = 20
var cast_time = 0.2
var ability_range = 700
var icon_texture = load("res://Images/Abilities/Icons/PillarOfFlame.png")
export var ability_slot = 0

func _ready():
	get_parent().connect("ability", self, "activate")
	get_parent().set_icon(ability_slot, icon_texture)

func activate(slot):
	var player_mana = get_parent().mana
	if slot == ability_slot:
		if player_mana>=mana_cost:
			if on_cooldown == false:
				if global_position.distance_to(get_global_mouse_position())<ability_range:
					get_parent().update_mana(-mana_cost)
					on_cooldown = true
					get_parent().rpc("set_status_effect", "slowed", cast_time)
					yield(get_tree().create_timer(cast_time), "timeout")
					get_parent().update_icon(ability_slot, cooldown)
					rpc("spawn_projectile",get_global_mouse_position())
					yield(get_tree().create_timer(cooldown), "timeout")
					on_cooldown = false
					get_parent().update_icon(ability_slot, 0)
				else:
					$RangeRing/Animation.stop()
					$RangeRing/Animation.play("Hide")
				

remotesync func spawn_projectile(pos):
	var projectile = preload("res://Scenes/Abilities/Projectiles/PillarOfFlame.tscn").instance()
	projectile.global_position=pos
	get_tree().get_root().add_child(projectile)
