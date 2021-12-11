extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health=100.0
var speed = 500
var attackSpeed = 2
var is_master = false
<<<<<<< Updated upstream
var speed = 700
var AttackSpeed = 2
=======
var dead = false
>>>>>>> Stashed changes
signal ability(slot)
# Called when the node enters the scene tree for the first time.
func initialize(id):
	name = str(id)
	if id == Network.client_id:
		rpc("set_appearance", Network.client_name)
		is_master = true
		$Camera.current=true

remotesync func set_appearance(p_name):
	$Name.text = p_name
	
func _process(delta):
	if is_master:
		var velocity = Vector2()
		if Input.is_action_pressed("up"):
<<<<<<< Updated upstream
			velocity.y = -1
		if Input.is_action_pressed("down"):
			velocity.y = 1
		if Input.is_action_pressed("left"):
			velocity.x = -1
		if Input.is_action_pressed("right"):
			velocity.x = 1
		if Input.is_action_pressed("ability1"):
			emit_signal("ability", 1)
		if Input.is_action_just_pressed("ability2"):
			emit_signal("ability", 2)
		if Input.is_action_just_pressed("ability3"):
			emit_signal("ability", 3)
		velocity=velocity.normalized()*speed
=======
			velocity.y = -speed
		if Input.is_action_pressed("down"):
			velocity.y = speed
		if Input.is_action_pressed("left"):
				velocity.x = -speed
		if Input.is_action_pressed("right"):
				velocity.x = speed
		if not dead:
			if Input.is_action_pressed("ability1"):
				emit_signal("ability", 1)
			if Input.is_action_just_pressed("ability2"):
				emit_signal("ability", 2)
			if Input.is_action_just_pressed("ability3"):
				emit_signal("ability", 3)
>>>>>>> Stashed changes
		velocity = move_and_slide(velocity)
		rpc_unreliable("update_position", position)
		
		#TOGGLES DEATHSCREEN WHEN PLAYER IS DEAD
		if health <= 0:
			$"/root/Game/CanvasLayer/DeathScreen".show()
			rpc("die")
		#KILL PLAYER - remove in future
		if Input.is_key_pressed(KEY_K):
			health = 0
remotesync func update_health(change):
	health=health+change
	$HealthBar.scale.x= float(health)/100.0
	if health<=0:
		queue_free()
remote func update_position(pos):
	position = pos
#TURNS PLAYER INTO A "GHOST" AT DEATH
remote func die():
	speed = 1500
	visible = false
	dead = true
