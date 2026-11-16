extends CanvasLayer

var edit_mode = false
var dragging = null
var drag_offset = Vector2.ZERO

var joystick_id = -1
var camera_touch_id = -1
var joystick_center = Vector2.ZERO
var move_vector = Vector2.ZERO
var last_camera_position = Vector2.ZERO
var player = null

const JOYSTICK_RADIUS = 50.0
const DEFAULT_JOYSTICK_POSITION = Vector2(40, 550)

@onready var fire_btn = $FireButton
@onready var jump_btn = $JumpButton
@onready var crouch_btn = $CrouchButton
@onready var aim_btn = $AimButton
@onready var prone_btn = $ProneButton
@onready var joystick = $JoystickBase
@onready var joystick_knob = $JoystickBase/Knob

func _ready():
    add_to_group("mobile_hud")
    aim_btn.toggle_mode = true
    $SettingsButton.pressed.connect(_open_settings)
    $EditHUDButton.pressed.connect(_toggle_edit)
    $SaveButton.pressed.connect(_save_layout)
    $ResetButton.pressed.connect(_reset_layout)
    $SizeSlider.value_changed.connect(_on_size_slider_changed)

    fire_btn.button_down.connect(_on_fire_pressed)
    fire_btn.button_up.connect(_on_fire_released)
    jump_btn.pressed.connect(_on_jump_pressed)
    crouch_btn.pressed.connect(_on_crouch_pressed)
    aim_btn.toggled.connect(_on_aim_toggled)
    prone_btn.pressed.connect(_on_prone_pressed)

    load_layout()
    joystick_center = joystick.position + joystick.size / 2

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

func _open_settings():
    if get_node_or_null("Settings") != null:
        return

    var settings_scene = preload("res://scenes/settings.tscn")
    var settings_instance = settings_scene.instantiate()
    settings_instance.name = "Settings"
    add_child(settings_instance)

func _toggle_edit():
    edit_mode = !edit_mode
    $SaveButton.visible = edit_mode
    $ResetButton.visible = edit_mode
    $SizeSlider.visible = edit_mode
    $EditLabel.visible = edit_mode
    $EditLabel.text = "وضع التعديل: اسحب أي زر لأي مكان"

func _input(event):
    if get_node_or_null("Settings") != null:
        return

    if edit_mode:
        handle_edit_input(event)
        return

    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x < get_viewport().size.x * 0.45 and joystick_id == -1:
                joystick_id = event.index
                joystick.position = event.position - joystick.size / 2
                joystick_center = event.position
                update_joystick(event.position)

            elif event.position.x >= get_viewport().size.x * 0.45 and camera_touch_id == -1:
                camera_touch_id = event.index
                last_camera_position = event.position
        else:
            if event.index == joystick_id:
                joystick_id = -1
                move_vector = Vector2.ZERO
                joystick_knob.position = joystick.size / 2 - joystick_knob.size / 2
                joystick.position = DEFAULT_JOYSTICK_POSITION
                joystick_center = joystick.position + joystick.size / 2

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

func handle_edit_input(event):
    if event is InputEventScreenTouch or event is InputEventMouseButton:
        if event.pressed:
            for btn in [fire_btn, jump_btn, crouch_btn, aim_btn, prone_btn, joystick]:
                if btn.get_global_rect().has_point(event.position):
                    dragging = btn
                    drag_offset = btn.position - event.position
                    break
        else:
            dragging = null

    if event is InputEventScreenDrag:
        if dragging:
            dragging.position = event.position + drag_offset

    if event is InputEventMouseMotion:
        if dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
            dragging.position = event.position + drag_offset

func update_joystick(position):
    var direction = position - joystick_center

    if direction.length() > JOYSTICK_RADIUS:
        direction = direction.normalized() * JOYSTICK_RADIUS

    joystick_knob.position = joystick.size / 2 - joystick_knob.size / 2 + direction
    move_vector = direction / JOYSTICK_RADIUS

func _on_fire_pressed():
    Input.action_press("shoot")

func _on_fire_released():
    Input.action_release("shoot")

func _on_jump_pressed():
    if player != null:
        player.request_mobile_jump()

func _on_crouch_pressed():
    if player != null:
        player.toggle_crouch()

func _on_aim_toggled(enabled):
    if player != null:
        player.set_aiming(enabled)

func _on_prone_pressed():
    if player != null:
        player.toggle_prone()

func _on_size_slider_changed(value):
    if dragging != null:
        dragging.scale = Vector2(value, value)

func _save_layout():
    var cfg = ConfigFile.new()

    for btn in [fire_btn, jump_btn, crouch_btn, aim_btn, prone_btn, joystick]:
        cfg.set_value("hud", btn.name + "_pos", btn.position)
        cfg.set_value("hud", btn.name + "_scale", btn.scale.x)

    cfg.save("user://hud.cfg")
    _toggle_edit()
    print("HUD SAVED")

func load_layout():
    var cfg = ConfigFile.new()

    if cfg.load("user://hud.cfg") != OK:
        return

    for btn in [fire_btn, jump_btn, crouch_btn, aim_btn, prone_btn, joystick]:
        if cfg.has_section_key("hud", btn.name + "_pos"):
            btn.position = cfg.get_value("hud", btn.name + "_pos")

        var saved_scale = cfg.get_value("hud", btn.name + "_scale", 1.0)
        btn.scale = Vector2(saved_scale, saved_scale)

func _reset_layout():
    var dir = DirAccess.open("user://")

    if dir and dir.file_exists("hud.cfg"):
        dir.remove("hud.cfg")

    get_tree().reload_current_scene()


func set_control_visibility(fire_enabled: bool, aim_enabled: bool, crouch_enabled: bool, prone_enabled: bool):
    fire_btn.visible = fire_enabled
    aim_btn.visible = aim_enabled
    crouch_btn.visible = crouch_enabled
    prone_btn.visible = prone_enabled
