extends Control

var title_label: Label
var subtitle_label: Label
var status_label: Label
var loading_bar: ProgressBar
var guest_button: Button
var google_button: Button
var email_input: LineEdit
var password_input: LineEdit
var password_toggle: Button
var signup_button: Button
var signin_button: Button
var stage := 0
var glow: ColorRect
var particles: Array[ColorRect] = []

func _ready():
    build_intro()
    FirebaseClient.auth_completed.connect(_on_firebase_auth_completed)

func build_intro():
    var background_image = TextureRect.new()
    background_image.texture = load("res://assets/login_bg.png")
    background_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    background_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(background_image)

    var bg = ColorRect.new()
    bg.color = Color(0.008, 0.008, 0.025, 0.48)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(bg)

    glow = ColorRect.new()
    glow.color = Color(0.22, 0.025, 0.38, 0.22)
    glow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(glow)

    var lines = Control.new()
    lines.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(lines)

    for i in range(18):
        var particle = ColorRect.new()
        particle.color = Color(0.75, 0.25, 1.0, randf_range(0.15, 0.65))
        particle.size = Vector2(randf_range(2, 5), randf_range(2, 5))
        particle.position = Vector2(randf_range(0, 700), randf_range(0, 1100))
        lines.add_child(particle)
        particles.append(particle)

    var center = VBoxContainer.new()
    center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    center.alignment = BoxContainer.ALIGNMENT_CENTER
    center.add_theme_constant_override("separation", 22)
    center.offset_left = 25
    center.offset_right = -25
    add_child(center)

    var top_space = Control.new()
    top_space.custom_minimum_size.y = 35
    center.add_child(top_space)

    title_label = Label.new()
    title_label.text = "SALAH"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 64)
    title_label.add_theme_color_override("font_color", Color(0.9, 0.55, 1.0))
    center.add_child(title_label)

    subtitle_label = Label.new()
    subtitle_label.text = "BATTLE ROYALE"
    subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.add_theme_font_size_override("font_size", 26)
    subtitle_label.add_theme_color_override("font_color", Color.WHITE)
    center.add_child(subtitle_label)

    var line = ColorRect.new()
    line.color = Color(0.65, 0.2, 1.0)
    line.custom_minimum_size = Vector2(180, 3)
    line.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    center.add_child(line)

    status_label = Label.new()
    status_label.text = "THE BATTLE IS ABOUT TO BEGIN"
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 14)
    status_label.add_theme_color_override("font_color", Color(0.72, 0.68, 0.82))
    center.add_child(status_label)

    loading_bar = ProgressBar.new()
    loading_bar.custom_minimum_size = Vector2(280, 8)
    loading_bar.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    loading_bar.indeterminate = true
    loading_bar.visible = false
    center.add_child(loading_bar)

    email_input = LineEdit.new()
    email_input.placeholder_text = "البريد الإلكتروني"
    email_input.custom_minimum_size = Vector2(280, 48)
    email_input.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    center.add_child(email_input)

    password_input = LineEdit.new()
    password_input.placeholder_text = "كلمة المرور"
    password_input.secret = true
    password_input.custom_minimum_size = Vector2(280, 48)
    password_input.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    center.add_child(password_input)

    password_toggle = Button.new()
    password_toggle.text = "إظهار كلمة المرور"
    password_toggle.custom_minimum_size = Vector2(280, 40)
    password_toggle.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    password_toggle.pressed.connect(_on_password_toggle_pressed)
    center.add_child(password_toggle)

    signup_button = Button.new()
    signup_button.text = "إنشاء حساب جديد"
    signup_button.custom_minimum_size = Vector2(280, 50)
    signup_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    signup_button.pressed.connect(_on_signup_pressed)
    center.add_child(signup_button)

    signin_button = Button.new()
    signin_button.text = "تسجيل الدخول"
    signin_button.custom_minimum_size = Vector2(280, 50)
    signin_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    signin_button.pressed.connect(_on_signin_pressed)
    center.add_child(signin_button)

    var spacer = Control.new()
    spacer.custom_minimum_size.y = 35
    center.add_child(spacer)

    google_button = Button.new()
    google_button.text = "CONTINUE WITH GOOGLE"
    google_button.custom_minimum_size = Vector2(280, 55)
    google_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    google_button.add_theme_font_size_override("font_size", 19)
    google_button.pressed.connect(_on_google_pressed)
    center.add_child(google_button)

    guest_button = Button.new()
    guest_button.text = "الدخول كضيف"
    guest_button.custom_minimum_size = Vector2(280, 60)
    guest_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    guest_button.add_theme_font_size_override("font_size", 22)

    var normal = StyleBoxFlat.new()
    normal.bg_color = Color(0.28, 0.06, 0.48)
    normal.border_color = Color(0.8, 0.35, 1.0)
    normal.set_border_width_all(2)
    normal.set_corner_radius_all(12)
    guest_button.add_theme_stylebox_override("normal", normal)

    var hover = normal.duplicate()
    hover.bg_color = Color(0.42, 0.1, 0.68)
    guest_button.add_theme_stylebox_override("hover", hover)

    guest_button.pressed.connect(_on_guest_pressed)
    center.add_child(guest_button)

    var footer = Label.new()
    footer.text = "SURVIVE • FIGHT • WIN"
    footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    footer.add_theme_font_size_override("font_size", 12)
    footer.add_theme_color_override("font_color", Color(0.55, 0.48, 0.65))
    center.add_child(footer)

    title_label.modulate.a = 0.0
    title_label.scale = Vector2(0.75, 0.75)

    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(title_label, "modulate:a", 1.0, 1.8)
    tween.tween_property(title_label, "scale", Vector2.ONE, 1.8)
    tween.tween_property(glow, "color:a", 0.5, 2.5)

func _process(delta):
    for particle in particles:
        particle.position.y -= 12.0 * delta
        if particle.position.y < -10:
            particle.position.y = get_viewport_rect().size.y + 10
            particle.position.x = randf_range(0, get_viewport_rect().size.x)

func _on_google_pressed():
    status_label.text = "Google غير مربوط بعد"
    _set_loading(false)
    print("GOOGLE LOGIN NOT CONNECTED YET")


func _on_guest_pressed():
    print("GUEST BUTTON PRESSED")
    _set_loading(true)
    status_label.text = "جاري الدخول كضيف..."

    var guest_id = Auth.login_as_guest()
    print("GUEST LOGIN ID: ", guest_id)

    guest_button.disabled = true
    google_button.disabled = true
    title_label.text = "LOADING"
    subtitle_label.text = "جاري تجهيز ساحة المعركة..."
    status_label.text = "GUEST PLAYER"
    guest_button.text = "انتظر..."

    await get_tree().create_timer(1.0).timeout

    print("OPENING LOBBY...")
    var error = get_tree().change_scene_to_file("res://scenes/lobby.tscn")

    if error != OK:
        push_error("LOBBY SCENE FAILED: " + str(error))
    else:
        print("LOBBY SCENE CHANGE REQUESTED")


func _on_signup_pressed():
    var email = email_input.text.strip_edges()
    var password = password_input.text

    if email.is_empty() or password.length() < 6:
        status_label.text = "أدخل البريد وكلمة مرور من 6 أحرف على الأقل"
        return

    status_label.text = "جاري إنشاء الحساب..."
    _set_loading(true)
    FirebaseClient.create_account(email, password)


func _on_signin_pressed():
    var email = email_input.text.strip_edges()
    var password = password_input.text

    if email.is_empty() or password.is_empty():
        status_label.text = "أدخل البريد وكلمة المرور"
        return

    status_label.text = "جاري تسجيل الدخول..."
    _set_loading(true)
    FirebaseClient.sign_in(email, password)


func _on_firebase_auth_completed(success: bool, data: Dictionary):
    if success:
        if not Auth.login_with_firebase(data):
            status_label.text = "تعذر ربط الحساب ببيانات اللاعب على هذا الجهاز"
            return

        status_label.text = "تم تسجيل الدخول بنجاح"
        _set_loading(false)
        print("FIREBASE ACCOUNT LINKED")
        get_tree().change_scene_to_file("res://scenes/lobby.tscn")
    else:
        status_label.text = "تعذر تسجيل الدخول: " + str(data.get("message", "خطأ غير معروف"))
        _set_loading(false)


func _on_password_toggle_pressed():
    password_input.secret = not password_input.secret
    password_toggle.text = "إخفاء كلمة المرور" if not password_input.secret else "إظهار كلمة المرور"


func _set_loading(active: bool):
    loading_bar.visible = active
    signup_button.disabled = active
    signin_button.disabled = active
    guest_button.disabled = active
    google_button.disabled = active
    email_input.editable = not active
    password_input.editable = not active
