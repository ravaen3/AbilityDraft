extends Node2D

export var cooldown = 2.0
export var cast_time = 0.0
export var mana_cost = 10.0
export var health_cost = 0.0
export var icon_texture = preload("res://Images/Abilities/Icons/Fireball.png")
export var projectile = preload("res://Scenes/Abilities/Projectiles/Fireball.tscn")
export var projectile_pattern = 1
export var projectile_spread = 0.1
export var spread_offset = 0.0
export var ability_damage = 0
export var projectile_speed = 1000
export var heal = 0
export var mana_heal = 0

var on_cooldown = false
var ability_slot = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("ability", self, "activate")
	get_parent().set_icon(ability_slot, icon_texture)

func activate(slot):
	var player_mana = get_parent().mana
	var player_health = get_parent().health
	if slot == ability_slot:
		if player_mana>=mana_cost:
			if player_health>=health_cost:
				if on_cooldown == false:
					if mana_cost:
						get_parent().rpc("update_mana",-mana_cost)
					if health_cost:
						get_parent().rpc("update_health",-health_cost)
					on_cooldown = true
					get_parent().interrupted=false
					if cast_time:
						get_parent().rpc("set_status_effect", "casting", cast_time)
						if cast_time:
							yield(get_tree().create_timer(cast_time), "timeout")
					if not get_parent().interrupted:
						rotation=0
						rotation=get_angle_to(get_global_mouse_position())+spread_offset
						for i in projectile_pattern:
							if projectile_pattern % 2 == 1:
								rpc("spawn_projectile",$Emitter.global_position,rotation)
								for p in (projectile_pattern-1)/2:
									rpc("spawn_projectile",$Emitter.global_position,rotation+(projectile_spread*(p+1)))
									rpc("spawn_projectile",$Emitter.global_position,rotation-(projectile_spread*(p+1)))
							else:
								for p in projectile_pattern/2:
									rpc("spawn_projectile",$Emitter.global_position,rotation+(projectile_spread*(p+1)))
									rpc("spawn_projectile",$Emitter.global_position,rotation-(projectile_spread*(p+1)))
						if heal:
							get_parent().rpc("update_health",heal)
						if mana_heal:
							get_parent().rpc("update_health",mana_heal)
					get_parent().update_icon(ability_slot, cooldown)
					yield(get_tree().create_timer(cooldown), "timeout")
					on_cooldown = false
					get_parent().update_icon(ability_slot, 0)

remotesync func spawn_projectile(pos, rot):
	var projectile_instance = projectile.instance()
	projectile_instance.global_position=pos
	projectile_instance.rotation=rot
	projectile_instance.damage = ability_damage
	projectile_instance.projectile_speed = projectile_speed
	get_tree().get_root().add_child(projectile_instance)
