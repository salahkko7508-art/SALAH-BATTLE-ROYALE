extends Control

const SAVE_PATH = "user://game_settings.cfg"

@onready var basic_panel = $BasicPanel
@onready var sensitivity_panel = $SensitivityPanel
@onready var controls_panel = $ControlsPanel

@onready var language_option = $BasicPanel/LanguageOption
@onready var save_toggle = $BasicPanel/SaveToggle
@onready var hints_toggle = $BasicPanel/HintsToggle
@onready var fire_confirm_toggle = $BasicPanel/FireConfirmToggle
@onready var damage_toggle = $BasicPanel/DamageToggle

@onready var fire_toggle = $ControlsPanel/FireToggle
@onready var aim_toggle = $ControlsPanel/AimToggle
@onready var auto_run_toggle = $ControlsPanel/AutoRunToggle
@onready var auto_jump_toggle = $ControlsPanel/AutoJumpToggle
@onready var crouch_toggle = $ControlsPanel/CrouchToggle
@onready var prone_toggle = $ControlsPanel/ProneToggle

func _ready():
    load_settings()

    $BasicButton.pressed.connect(_show_basic)
    $SensitivityButton.pressed.connect(_show_sensitivity)
    $ControlsButton.pressed.connect(_show_controls)
    $CloseButton.pressed.connect(_close_settings)

    language_option.item_selected.connect(_on_setting_changed)
    save_toggle.toggled.connect(_on_save_toggled)
    hints_toggle.toggled.connect(_on_setting_changed)
    fire_confirm_toggle.toggled.connect(_on_setting_changed)
    damage_toggle.toggled.connect(_on_setting_changed)

    for toggle in [
        fire_toggle, aim_toggle, auto_run_toggle,
        auto_jump_toggle, crouch_toggle, prone_toggle
    ]:
        toggle.toggled.connect(_on_setting_changed)

    setup_sensitivity()
    apply_control_settings()

func _show_basic():
    basic_panel.visible = true
    sensitivity_panel.visible = false
    controls_panel.visible = false

func _show_sensitivity():
    basic_panel.visible = false
    sensitivity_panel.visible = true
    controls_panel.visible = false

func _show_controls():
    basic_panel.visible = false
    sensitivity_panel.visible = false
    controls_panel.visible = true

func setup_sensitivity():
    var controls = [
        ["general", $SensitivityPanel/GeneralSlider, $SensitivityPanel/GeneralLabel],
        ["red_dot", $SensitivityPanel/RedDotSlider, $SensitivityPanel/RedDotLabel],
        ["scope_2x", $SensitivityPanel/Scope2Slider, $SensitivityPanel/Scope2Label],
        ["scope_4x", $SensitivityPanel/Scope4Slider, $SensitivityPanel/Scope4Label],
        ["sniper", $SensitivityPanel/SniperSlider, $SensitivityPanel/SniperLabel],
        ["free_look", $SensitivityPanel/FreeLookSlider, $SensitivityPanel/FreeLookLabel]
    ]

    for item in controls:
        var key = item[0]
        var slider = item[1]
        var label = item[2]
        slider.value_changed.connect(_on_sensitivity_changed.bind(key, label))
        update_sensitivity_label(slider.value, key, label)

func _on_sensitivity_changed(value, key, label):
    update_sensitivity_label(value, key, label)

    if key == "general":
        var players = get_tree().get_nodes_in_group("local_player")
        if players.size() > 0:
            players[0].set_camera_sensitivity(value)

    save_settings()

func update_sensitivity_label(value, key, label):
    var names = {
        "general": "General",
        "red_dot": "Red Dot",
        "scope_2x": "2X Scope",
        "scope_4x": "4X Scope",
        "sniper": "Sniper",
        "free_look": "Free Look"
    }

    label.text = names[key] + ": " + str(int(value))

func _on_setting_changed(_value):
    apply_control_settings()
    save_settings()

func _on_save_toggled(_value):
    save_settings(true)

func apply_control_settings():
    var players = get_tree().get_nodes_in_group("local_player")

    for current_player in players:
        current_player.set_auto_run(auto_run_toggle.button_pressed)
        current_player.set_auto_jump(auto_jump_toggle.button_pressed)
        current_player.set_crouch(crouch_toggle.button_pressed)
        current_player.set_prone(prone_toggle.button_pressed)

    var huds = get_tree().get_nodes_in_group("mobile_hud")

    for hud in huds:
        hud.set_control_visibility(
            fire_toggle.button_pressed,
            aim_toggle.button_pressed,
            crouch_toggle.button_pressed,
            prone_toggle.button_pressed
        )

func save_settings(force = false):
    if not save_toggle.button_pressed and not force:
        return

    var config = ConfigFile.new()

    config.set_value("basic", "language", language_option.selected)
    config.set_value("basic", "auto_save", save_toggle.button_pressed)
    config.set_value("basic", "hints", hints_toggle.button_pressed)
    config.set_value("basic", "fire_confirmation", fire_confirm_toggle.button_pressed)
    config.set_value("basic", "damage_numbers", damage_toggle.button_pressed)

    config.set_value("controls", "fire", fire_toggle.button_pressed)
    config.set_value("controls", "aim", aim_toggle.button_pressed)
    config.set_value("controls", "auto_run", auto_run_toggle.button_pressed)
    config.set_value("controls", "auto_jump", auto_jump_toggle.button_pressed)
    config.set_value("controls", "crouch", crouch_toggle.button_pressed)
    config.set_value("controls", "prone", prone_toggle.button_pressed)

    config.set_value("sensitivity", "general", $SensitivityPanel/GeneralSlider.value)
    config.set_value("sensitivity", "red_dot", $SensitivityPanel/RedDotSlider.value)
    config.set_value("sensitivity", "scope_2x", $SensitivityPanel/Scope2Slider.value)
    config.set_value("sensitivity", "scope_4x", $SensitivityPanel/Scope4Slider.value)
    config.set_value("sensitivity", "sniper", $SensitivityPanel/SniperSlider.value)
    config.set_value("sensitivity", "free_look", $SensitivityPanel/FreeLookSlider.value)

    config.save(SAVE_PATH)

func load_settings():
    var config = ConfigFile.new()

    if config.load(SAVE_PATH) != OK:
        return

    language_option.select(config.get_value("basic", "language", 0))
    save_toggle.button_pressed = config.get_value("basic", "auto_save", true)
    hints_toggle.button_pressed = config.get_value("basic", "hints", true)
    fire_confirm_toggle.button_pressed = config.get_value("basic", "fire_confirmation", true)
    damage_toggle.button_pressed = config.get_value("basic", "damage_numbers", true)

    fire_toggle.button_pressed = config.get_value("controls", "fire", true)
    aim_toggle.button_pressed = config.get_value("controls", "aim", true)
    auto_run_toggle.button_pressed = config.get_value("controls", "auto_run", false)
    auto_jump_toggle.button_pressed = config.get_value("controls", "auto_jump", true)
    crouch_toggle.button_pressed = config.get_value("controls", "crouch", true)
    prone_toggle.button_pressed = config.get_value("controls", "prone", true)

    $SensitivityPanel/GeneralSlider.value = config.get_value("sensitivity", "general", 95)
    $SensitivityPanel/RedDotSlider.value = config.get_value("sensitivity", "red_dot", 90)
    $SensitivityPanel/Scope2Slider.value = config.get_value("sensitivity", "scope_2x", 85)
    $SensitivityPanel/Scope4Slider.value = config.get_value("sensitivity", "scope_4x", 80)
    $SensitivityPanel/SniperSlider.value = config.get_value("sensitivity", "sniper", 50)
    $SensitivityPanel/FreeLookSlider.value = config.get_value("sensitivity", "free_look", 75)

func _close_settings():
    queue_free()
