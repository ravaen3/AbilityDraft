extends KinematicBody2D
var max_health=100
var max_mana=100
var health=100.0
var mana=100.0
var mana_regen=5.0
var health_regen=1.0
var is_master = false


var speed = 500
var velocity = Vector2()
var dead = false
var stunned = 0
var silenced = 0
var rooted = 0
var slowed = 0
var casting = 0
var interrupted = false

signal ability(slot)

func initialize(id):
	name = str(id)
	if id == Network.client_id:
		rpc("set_appearance", Network.client_name)
		is_master = true
		$Camera.current=true
		var ability_id=1
		for ability in Network.client_abilities:
			rpc("add_ability", ability, ability_id)
			ability_id+=1
	randomize()
	position = Vector2(randi()% 1000,randi()% 1000)

remotesync func add_ability(ability, id):
	var ability_scene = load("res://Scenes/Abilities/"+ability+".tscn").instance()
	ability_scene.ability_slot=id
	add_child(ability_scene)

remotesync func set_appearance(p_name):
	$Name.text = p_name
	
remotesync func set_status_effect(effect, duration):
	if effect == "slowed":
		slowed +=duration
	elif effect == "stunned":
		stunned +=duration
		if casting:
			interrupted=true
			casting = 0
	elif effect == "silenced":
		silenced+=duration
		if casting:
			interrupted=true
			casting = 0
	elif effect == "rooted":
		rooted+=duration
	elif effect == "casting":
		casting+=duration
	
func update_status(status,delta):
	if status:
		status -= delta
		if status < 0:
			status= 0
	return status

	
func _process(delta):
	slowed=update_status(slowed,delta)
	stunned=update_status(stunned,delta)
	silenced=update_status(silenced,delta)
	rooted=update_status(rooted,delta)
	casting=update_status(casting,delta)
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
		if not dead && not stunned && not silenced && not casting:
			if Input.is_action_pressed("ability1"):
				emit_signal("ability", 1)
			if Input.is_action_pressed("ability2"):
				emit_signal("ability", 2)
			if Input.is_action_pressed("ability3"):
				emit_signal("ability", 3)
		if slowed || casting:
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
			rpc("ghostify")
		#KILL PLAYER - remove in future
		if Input.is_key_pressed(KEY_K):
			health = 0
	else:
		velocity=move_and_slide(velocity)
			
func set_icon(ability_slot, texture):
	if is_master:
		$HUD.get_node("Ability"+String(ability_slot)).set_texture(texture)
func update_icon(ability_slot, cooldown):
	if is_master:
		if cooldown:
			$HUD.get_node("Ability"+String(ability_slot)).get_node("CDDisplay").get_node("Animation").playback_speed=1.0/cooldown
			$HUD.get_node("Ability"+String(ability_slot)).get_node("CDDisplay").get_node("Animation").play("Cooldown")
		else:
			pass

remotesync func update_mana(change):
	if mana+change>max_mana:
		mana=max_mana
	else:
		mana+=change
		
	$ManaBar.scale.x= float(mana)/100.0

remotesync func update_health(change):
	if health+change>max_health:
		health=max_health
	else:
		health+=change
		
	$HealthBar.scale.x= float(health)/100.0

remote func update_position(pos, rot):
	$Sprite.rotation = rot
	position = pos

remotesync func ghostify():
	if is_master:
		pass
	else:
		hide()
	speed = 1500
	dead = true
	$Collision.disabled=true


func _on_RegenTimer_timeout():
	if mana<max_mana:
		rpc("update_mana", mana_regen)
	if health<max_health:
		rpc("update_health",health_regen)
