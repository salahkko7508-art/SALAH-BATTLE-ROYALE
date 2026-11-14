extends CharacterBody3D

@export var speed = 5.0
@export var run_speed = 9.0
@export var hp = 100
@export var max_hp = 100
@export var is_alive = true

var current_speed = 5.0

func _physics_process(delta):
	if not is_alive:
		return
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1

	if Input.is_action_pressed("ui_accept"):
		current_speed = run_speed
	else:
		current_speed = speed

	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = dir.x * current_speed
	velocity.z = dir.z * current_speed
	move_and_slide()

func take_damage(amount):
	if not is_alive:
		return
	hp -= amount
	print("HP: ", hp)
	if hp <= 0:
		die()

func heal(amount):
	hp = min(hp + amount, max_hp)
	print("HP: ", hp)

func die():
	is_alive = false
	hp = 0
	print("GAME OVER")
