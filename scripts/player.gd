extends CharacterBody3D

@export var speed = 5.0
@export var run_speed = 9.0
@export var jump_velocity = 6.0
@export var hp = 100
@export var max_hp = 100
@export var is_alive = true

var camera_sensitivity = 0.003
var current_speed = 5.0
var mobile_input = Vector2.ZERO
var mobile_jump_requested = false

var auto_run_enabled = false
var auto_jump_enabled = true
var crouch_enabled = true
var prone_enabled = true

var is_crouching = false
var is_prone = false
var is_aiming = false

var normal_camera_fov = 75.0
var normal_camera_height = 0.0

@onready var camera: Camera3D = $Camera3D

func _ready():
    add_to_group("local_player")
    if camera:
        normal_camera_fov = camera.fov
        normal_camera_height = camera.position.y

func set_mobile_input(direction: Vector2):
    mobile_input = direction.limit_length(1.0)

func set_camera_sensitivity(value: float):
    camera_sensitivity = 0.003 * (value / 95.0)

func rotate_camera(touch_delta: Vector2):
    rotate_y(-touch_delta.x * camera_sensitivity)
    if camera:
        camera.rotation.x = clamp(
            camera.rotation.x - touch_delta.y * camera_sensitivity,
            -0.8,
            0.3
        )

func request_mobile_jump():
    mobile_jump_requested = true

func set_auto_run(enabled: bool):
    auto_run_enabled = enabled

func set_auto_jump(enabled: bool):
    auto_jump_enabled = enabled

func set_crouch(enabled: bool):
    crouch_enabled = enabled
    if not enabled:
        is_crouching = false

func set_prone(enabled: bool):
    prone_enabled = enabled
    if not enabled:
        is_prone = false

func set_aiming(enabled: bool):
    is_aiming = enabled
    if camera:
        camera.fov = 55.0 if is_aiming else normal_camera_fov

func toggle_crouch():
    if crouch_enabled:
        is_crouching = not is_crouching
        if is_crouching:
            is_prone = false

func toggle_prone():
    if prone_enabled:
        is_prone = not is_prone
        if is_prone:
            is_crouching = false

func _physics_process(delta):
    if not is_alive:
        return

    if not is_on_floor():
        velocity += get_gravity() * delta
    elif velocity.y < 0:
        velocity.y = 0

    if (Input.is_action_just_pressed("ui_accept") or mobile_jump_requested) and is_on_floor() and (auto_jump_enabled or mobile_jump_requested or Input.is_action_just_pressed("ui_accept")):
        velocity.y = jump_velocity

    mobile_jump_requested = false

    var input_dir = mobile_input

    if Input.is_action_pressed("ui_right"):
        input_dir.x += 1
    if Input.is_action_pressed("ui_left"):
        input_dir.x -= 1
    if Input.is_action_pressed("ui_down"):
        input_dir.y += 1
    if Input.is_action_pressed("ui_up"):
        input_dir.y -= 1

    input_dir = input_dir.limit_length(1.0)

    var moving = input_dir.length() > 0.01
    var running = auto_run_enabled or Input.is_key_pressed(KEY_SHIFT)

    current_speed = run_speed if running else speed

    if is_crouching:
        current_speed *= 0.55
    elif is_prone:
        current_speed *= 0.25

    if running and not moving:
        input_dir.y = -1.0

    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    velocity.x = direction.x * current_speed
    velocity.z = direction.z * current_speed

    if camera:
        var target_height = normal_camera_height
        if is_crouching:
            target_height -= 0.45
        elif is_prone:
            target_height -= 0.9

        camera.position.y = lerp(camera.position.y, target_height, delta * 8.0)

    move_and_slide()

func take_damage(amount):
    if not is_alive:
        return

    hp = max(hp - amount, 0)
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
