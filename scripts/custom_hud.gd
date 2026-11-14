extends CanvasLayer

var edit_mode = false
var dragging = null
var drag_offset = Vector2.ZERO

@onready var fire_btn = $FireButton
@onready var jump_btn = $JumpButton
@onready var crouch_btn = $CrouchButton
@onready var joystick = $JoystickBase

func _ready():
load_layout()
$SettingsButton.pressed.connect(_toggle_edit)
$SaveButton.pressed.connect(_save_layout)
$ResetButton.pressed.connect(_reset_layout)

func _toggle_edit():
edit_mode = !edit_mode
$SaveButton.visible = edit_mode
$ResetButton.visible = edit_mode
$SizeSlider.visible = edit_mode
$EditLabel.visible = edit_mode
$EditLabel.text = "وضع التعديل: اسحب أي زر لأي مكان"

func _input(event):
if !edit_mode: return
if event is InputEventScreenTouch or event is InputEventMouseButton:
if event.pressed:
for btn in [fire_btn, jump_btn, crouch_btn, joystick]:
if btn.get_global_rect().has_point(event.position):
dragging = btn
drag_offset = btn.position - event.position
break
else:
dragging = null
if event is InputEventScreenDrag or event is InputEventMouseMotion:
if dragging and event is InputEventScreenDrag:
dragging.position = event.position + drag_offset
elif dragging and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
dragging.position = event.position + drag_offset

func _on_size_slider_changed(value):
if dragging:
dragging.scale = Vector2(value, value)

func _save_layout():
var cfg = ConfigFile.new()
for btn in [fire_btn, jump_btn, crouch_btn, joystick]:
cfg.set_value("hud", btn.name + "_pos", btn.position)
cfg.set_value("hud", btn.name + "_scale", btn.scale.x)
cfg.save("user://hud.cfg")
_toggle_edit()
print("HUD SAVED")

func load_layout():
var cfg = ConfigFile.new()
if cfg.load("user://hud.cfg") != OK: return
for btn in [fire_btn, jump_btn, crouch_btn, joystick]:
if cfg.has_section_key("hud", btn.name + "_pos"):
btn.position = cfg.get_value("hud", btn.name + "_pos")
btn.scale = Vector2(cfg.get_value("hud", btn.name + "_scale", 1.0), cfg.get_value("hud", btn.name + "_scale", 1.0))

func _reset_layout():
var dir = DirAccess.open("user://")
if dir.file_exists("hud.cfg"):
dir.remove("hud.cfg")
get_tree().reload_current_scene()
