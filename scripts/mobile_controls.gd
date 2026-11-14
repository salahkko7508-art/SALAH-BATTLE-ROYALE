extends CanvasLayer

@onready var joystick_base = $JoystickBase
@onready var joystick_knob = $JoystickBase/Knob
@onready var fire_btn = $FireButton
@onready var jump_btn = $JumpButton

var joystick_active = false
var joystick_id = -1
var joystick_center = Vector2.ZERO
var move_vector = Vector2.ZERO

func _ready():
joystick_center = joystick_base.position + joystick_base.size / 2

func _input(event):
if event is InputEventScreenTouch:
if event.pressed and event.position.x < get_viewport().size.x / 2:
joystick_active = true
joystick_id = event.index
joystick_base.position = event.position - joystick_base.size / 2
joystick_center = event.position
elif not event.pressed and event.index == joystick_id:
joystick_active = false
joystick_knob.position = joystick_base.size / 2 - joystick_knob.size / 2
move_vector = Vector2.ZERO
Input.action_release("move_forward")
Input.action_release("move_back")
Input.action_release("move_left")
Input.action_release("move_right")
if event is InputEventScreenDrag and event.index == joystick_id:
var dir = event.position - joystick_center
if dir.length() > 50:
dir = dir.normalized() * 50
joystick_knob.position = joystick_base.size / 2 - joystick_knob.size / 2 + dir
move_vector = dir / 50.0
# نحول الجوستك لـ WASD
if move_vector.y < -0.3: Input.action_press("move_forward")
else: Input.action_release("move_forward")
if move_vector.y > 0.3: Input.action_press("move_back")
else: Input.action_release("move_back")
if move_vector.x < -0.3: Input.action_press("move_left")
else: Input.action_release("move_left")
if move_vector.x > 0.3: Input.action_press("move_right")
else: Input.action_release("move_right")

func _on_fire_button_pressed():
Input.action_press("shoot")

func _on_fire_button_released():
Input.action_release("shoot")

func _on_jump_button_pressed():
Input.action_press("jump")
