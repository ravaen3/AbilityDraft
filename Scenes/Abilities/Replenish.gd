extends Node2D


var is_master = false
var cooldown = 5
var on_cooldown = false
var mana_cost = 40
var icon_texture = load("res://Images/Abilities/Icons/Replenish.png")
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
				get_parent().update_health(20)
				get_parent().update_icon(ability_slot, on_cooldown)
				yield(get_tree().create_timer(cooldown), "timeout")
				on_cooldown = false
				get_parent().update_icon(ability_slot, on_cooldown)
