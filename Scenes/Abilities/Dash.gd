extends Node2D

var is_master = false
var cooldown = 2
var on_cooldown = false
var dash_speed = 3
var duration = 0.1
var icon_texture = load("res://Images/Abilities/Icons/Dash.png")
export var ability_slot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("ability", self, "activate")
	get_parent().set_icon(ability_slot, icon_texture)

func activate(slot):
	if slot == ability_slot:
		if get_parent().velocity != Vector2(0,0):
			
			if on_cooldown == false:
				on_cooldown = true
				get_parent().update_icon(ability_slot, cooldown)
				rotation=0
				rotation=get_angle_to(get_global_mouse_position())
				get_parent().speed=get_parent().speed*dash_speed
				yield(get_tree().create_timer(duration), "timeout")
				get_parent().speed=get_parent().speed/dash_speed
				yield(get_tree().create_timer(cooldown), "timeout")
				on_cooldown = false
				get_parent().update_icon(ability_slot, 0)
