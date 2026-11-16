extends CanvasLayer

@onready var joystick_base = $JoystickBase
@onready var joystick_knob = $JoystickBase/Knob
@onready var fire_btn = $FireButton
@onready var jump_btn = $JumpButton

var joystick_id = -1
var camera_touch_id = -1
var joystick_center = Vector2.ZERO
var move_vector = Vector2.ZERO
var last_camera_position = Vector2.ZERO
var player = null

const JOYSTICK_RADIUS = 50.0

func _ready():
    joystick_center = joystick_base.position + joystick_base.size / 2

    fire_btn.button_down.connect(_on_fire_pressed)
    fire_btn.button_up.connect(_on_fire_released)
    jump_btn.pressed.connect(_on_jump_pressed)

    await get_tree().process_frame
    find_player()

func find_player():
    var players = get_tree().get_nodes_in_group("local_player")

    if players.size() > 0:
        player = players[0]

func _process(_delta):
    if player == null:
        find_player()

    if player != null:
        player.set_mobile_input(move_vector)

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x < get_viewport().size.x * 0.45 and joystick_id == -1:
                joystick_id = event.index
                joystick_base.position = event.position - joystick_base.size / 2
                joystick_center = event.position
                update_joystick(event.position)

            elif event.position.x >= get_viewport().size.x * 0.45 and camera_touch_id == -1:
                camera_touch_id = event.index
                last_camera_position = event.position

        else:
            if event.index == joystick_id:
                joystick_id = -1
                move_vector = Vector2.ZERO
                joystick_knob.position = joystick_base.size / 2 - joystick_knob.size / 2

            if event.index == camera_touch_id:
                camera_touch_id = -1

    elif event is InputEventScreenDrag:
        if event.index == joystick_id:
            update_joystick(event.position)

        elif event.index == camera_touch_id:
            var delta_touch = event.position - last_camera_position
            last_camera_position = event.position

            if player != null:
                player.rotate_camera(delta_touch)

func update_joystick(position):
    var direction = position - joystick_center

    if direction.length() > JOYSTICK_RADIUS:
        direction = direction.normalized() * JOYSTICK_RADIUS

    joystick_knob.position = joystick_base.size / 2 - joystick_knob.size / 2 + direction
    move_vector = direction / JOYSTICK_RADIUS

func _on_fire_pressed():
    Input.action_press("shoot")

func _on_fire_released():
    Input.action_release("shoot")

func _on_jump_pressed():
    Input.action_press("jump")
