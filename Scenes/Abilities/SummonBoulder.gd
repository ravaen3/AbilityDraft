extends Node2D


var is_master = false
var cooldown = 2
var on_cooldown = false
var mana_cost = 25
var icon_texture = load("res://Images/Abilities/Icons/SummonBoulder.png")
export var ability_slot = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("ability", self, "activate")
	get_parent().set_icon(ability_slot, icon_texture)
	
func activate(slot):
	var player_mana = get_parent().mana
	if slot == ability_slot:
		if player_mana>=mana_cost:
			if on_cooldown == false:
				get_parent().rpc("update_mana",-mana_cost)
				on_cooldown = true
				get_parent().update_icon(ability_slot, on_cooldown)
				rotation=0
				rotation=get_angle_to(get_global_mouse_position())
				rpc("spawn_projectile",$Emitter.global_position,rotation)
				yield(get_tree().create_timer(cooldown), "timeout")
				on_cooldown = false
				get_parent().update_icon(ability_slot, on_cooldown)

remotesync func spawn_projectile(pos, rot):
	var projectile = preload("res://Scenes/Abilities/Projectiles/SummonBoulder.tscn").instance()
	projectile.global_position=pos
	projectile.rotation=rot
	get_tree().get_root().add_child(projectile)
