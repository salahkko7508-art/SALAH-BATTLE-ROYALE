extends CharacterBody3D

const SPEED = 6.0
const SENSITIVITY = 0.003
const SYNC_RATE = 0.05

var move_input = Vector2.ZERO
var server_direction = Vector2.ZERO
var server_camera_yaw = 0.0
var camera_yaw = 0.0
var server_yaw = 0.0
var remote_position = Vector3.ZERO
var sync_timer = 0.0

var camera_pivot: Node3D
var camera: Camera3D

func _ready():
    build_character()
    remote_position = global_position

    if is_multiplayer_authority():
        add_to_group("local_player")
        setup_camera()

func build_character():
    var skin = StandardMaterial3D.new()
    skin.albedo_color = Color(0.9, 0.7, 0.5)

    var head = MeshInstance3D.new()
    head.mesh = SphereMesh.new()
    head.mesh.radius = 0.3
    head.position = Vector3(0, 1.5, 0)
    head.material_override = skin
    add_child(head)

    var shirt = StandardMaterial3D.new()
    shirt.albedo_color = Color(0.0, 0.3, 0.9)

    var body = MeshInstance3D.new()
    body.mesh = BoxMesh.new()
    body.mesh.size = Vector3(0.6, 0.7, 0.35)
    body.position = Vector3(0, 0.8, 0)
    body.material_override = shirt
    add_child(body)

    var pants = StandardMaterial3D.new()
    pants.albedo_color = Color(0.1, 0.1, 0.1)

    var legs = MeshInstance3D.new()
    legs.mesh = BoxMesh.new()
    legs.mesh.size = Vector3(0.5, 0.6, 0.3)
    legs.position = Vector3(0, 0.15, 0)
    legs.material_override = pants
    add_child(legs)

func setup_camera():
    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0, 1.5, 0)
    add_child(camera_pivot)

    camera = Camera3D.new()
    camera.position = Vector3(0, 1.5, 5)
    camera.rotation_degrees.x = -12
    camera_pivot.add_child(camera)
    camera.current = true

func set_mobile_input(direction: Vector2):
    move_input = direction.limit_length(1.0)

func rotate_camera(touch_delta: Vector2):
    if camera_pivot == null:
        return

    camera_pivot.rotation.y -= touch_delta.x * SENSITIVITY
    camera_yaw = camera_pivot.rotation.y
    camera.rotation.x = clamp(
        camera.rotation.x - touch_delta.y * SENSITIVITY,
        -0.8,
        0.3
    )

func _physics_process(delta):
    if multiplayer.is_server():
        if get_multiplayer_authority() == 1:
            server_direction = move_input if move_input.length() > 0.01 else read_keyboard()
            server_camera_yaw = camera_yaw

        var move_dir = Vector3(server_direction.x, 0, server_direction.y).rotated(Vector3.UP, server_camera_yaw)
        velocity.x = move_dir.x * SPEED
        velocity.z = move_dir.z * SPEED
        move_and_slide()

        sync_timer += delta
        if sync_timer >= SYNC_RATE:
            sync_timer = 0.0
            rpc("receive_position", global_position)

    elif is_multiplayer_authority():
        rpc_id(1, "submit_input", move_input, camera_yaw)

    else:
        global_position = global_position.lerp(remote_position, 0.25)

func read_keyboard():
    var direction = Vector2.ZERO

    if Input.is_key_pressed(KEY_W):
        direction.y -= 1
    if Input.is_key_pressed(KEY_S):
        direction.y += 1
    if Input.is_key_pressed(KEY_A):
        direction.x -= 1
    if Input.is_key_pressed(KEY_D):
        direction.x += 1

    return direction.normalized()

@rpc("any_peer", "call_remote", "unreliable")
func submit_input(direction: Vector2, yaw: float):
    if not multiplayer.is_server():
        return

    if multiplayer.get_remote_sender_id() != get_multiplayer_authority():
        return

    server_direction = direction.limit_length(1.0)
    server_camera_yaw = yaw

@rpc("any_peer", "call_remote", "unreliable")
func receive_position(pos: Vector3):
    if multiplayer.get_remote_sender_id() != 1:
        return

    remote_position = pos
