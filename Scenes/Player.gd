extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health=100.0
var is_master = false
var speed = 700
var AttackSpeed = 2
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
		velocity = move_and_slide(velocity)
		rpc_unreliable("update_position", position)
	
remotesync func update_health(change):
	health=health+change
	$HealthBar.scale.x= float(health)/100.0
	if health<=0:
		queue_free()
remote func update_position(pos):
	position = pos
