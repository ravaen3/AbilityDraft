extends KinematicBody2D
var max_health=100
var max_mana=100
var health=100.0
var mana=100.0
var mana_regen=5.0
var health_regen=1.0
var is_master = false

var speed = 700
var velocity = Vector2()
var dead = false
var stunned = 0
var silenced = 0
var rooted = 0
var slowed = 0

signal ability(slot)

func initialize(id):
	name = str(id)
	if id == Network.client_id:
		rpc("set_appearance", Network.client_name)
		is_master = true
		$Camera.current=true
	
	var ability_id=1
	for ability in Network.client_abilities:
		var ability_scene = load("res://Scenes/Abilities/"+ability+".tscn").instance()
		ability_scene.ability_slot=ability_id
		add_child(ability_scene)
		ability_id+=1

remotesync func set_appearance(p_name):
	$Name.text = p_name
	
remotesync func set_status_effect(effect, duration):
	if effect == "slowed":
		slowed +=duration
	elif effect == "stunned":
		stunned +=duration
	elif effect == "silenced":
		silenced+=duration
	elif effect == "rooted":
		rooted+=duration
	
		
func _process(delta):
	if slowed:
		slowed -= delta
		if slowed < 0:
			slowed = 0
	if stunned:
		stunned -= delta
		if stunned < 0:
			stunned = 0
	if silenced:
		silenced -= delta
		if silenced <0:
			silenced = 0
	if rooted:
		rooted -= delta
		if rooted <0:
			rooted = 0
			
	if is_master:
		velocity = Vector2()
		if Input.is_action_pressed("up"):
			velocity.y = -1
		if Input.is_action_pressed("down"):
			velocity.y = 1
		if Input.is_action_pressed("left"):
			velocity.x = -1
		if Input.is_action_pressed("right"):
			velocity.x = 1
		if not dead && not stunned && not silenced:
			if Input.is_action_pressed("ability1"):
				emit_signal("ability", 1)
			if Input.is_action_just_pressed("ability2"):
				emit_signal("ability", 2)
			if Input.is_action_just_pressed("ability3"):
				emit_signal("ability", 3)
		if slowed:
			velocity=velocity.normalized()*speed/2
		else:
			velocity=velocity.normalized()*speed
		if not rooted && not stunned:
			velocity=move_and_slide(velocity)
		$Sprite.rotation=get_angle_to(get_global_mouse_position())
		rpc_unreliable("update_position", position, $Sprite.rotation)
		
		#TOGGLES DEATHSCREEN WHEN PLAYER IS DEAD
		if health <= 0:
			$"/root/Game/CanvasLayer/DeathScreen".show()
			rpc("die")
		#KILL PLAYER - remove in future
		if Input.is_key_pressed(KEY_K):
			health = 0
	else:
		velocity=move_and_slide(velocity)
			
func set_icon(ability_slot, texture):
	if is_master:
		$HUD.get_node("Ability"+String(ability_slot)).set_texture(texture)
func update_icon(ability_slot, on_cooldown):
	if is_master:
		if on_cooldown:
			$HUD.get_node("Ability"+String(ability_slot)).modulate = Color(0.5,0.5,0.5)
		else:
			$HUD.get_node("Ability"+String(ability_slot)).modulate = Color(1,1,1)
remotesync func update_mana(change):
	mana=mana+change
	if mana>max_mana:
		mana=max_mana
	$ManaBar.scale.x= float(mana)/100.0
		
remotesync func update_health(change):
	health=health+change
	if health>max_health:
		health=max_health
	$HealthBar.scale.x= float(health)/100.0

remote func update_position(pos, rot):
	$Sprite.rotation = rot
	position = pos

remote func die():
	speed = 1500
	hide()
	dead = true
	$Collision.disabled=true


func _on_RegenTimer_timeout():
	if mana<max_mana:
		rpc("update_mana", mana_regen)
	if health<max_health:
		rpc("update_health",health_regen)
