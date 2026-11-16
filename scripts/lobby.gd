extends Control

var selected_tab = "home"

func _ready():
    print("SALAH LOBBY READY")
    build_lobby()

func build_lobby():
    for child in get_children():
        child.queue_free()

    var bg = ColorRect.new()
    bg.color = Color(0.025, 0.018, 0.07)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var root = VBoxContainer.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.add_theme_constant_override("separation", 12)
    root.add_theme_constant_override("margin_left", 24)
    root.add_theme_constant_override("margin_right", 24)
    root.add_theme_constant_override("margin_top", 24)
    root.add_theme_constant_override("margin_bottom", 24)
    add_child(root)

    var header = HBoxContainer.new()
    root.add_child(header)

    var profile = Label.new()
    profile.text = Auth.player_name + "   |   " + Auth.player_id
    profile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    profile.add_theme_font_size_override("font_size", 17)
    header.add_child(profile)

    var level = Label.new()
    level.text = "LEVEL " + str(Auth.player_level)
    header.add_child(level)

    var title = Label.new()
    title.text = "SALAH BATTLE ROYALE"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 28)
    title.add_theme_color_override("font_color", Color(0.85, 0.55, 1.0))
    root.add_child(title)

    var spacer = Control.new()
    spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.add_child(spacer)

    var character = Label.new()
    character.text = "⚔\n\n" + Global.selected_character.to_upper() + "\n" + Global.selected_outfit.to_upper()
    character.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    character.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    character.size_flags_vertical = Control.SIZE_EXPAND_FILL
    character.add_theme_font_size_override("font_size", 30)
    root.add_child(character)

    var play = Button.new()
    play.text = "BATTLE ROYALE  -  PLAY"
    play.custom_minimum_size.y = 75
    play.add_theme_font_size_override("font_size", 24)
    play.pressed.connect(_on_play)
    root.add_child(play)

    var tabs = GridContainer.new()
    tabs.columns = 3
    tabs.add_theme_constant_override("h_separation", 8)
    tabs.add_theme_constant_override("v_separation", 8)
    root.add_child(tabs)

    add_tab(tabs, "المتجر", "shop")
    add_tab(tabs, "الملابس", "wardrobe")
    add_tab(tabs, "الأصدقاء", "friends")
    add_tab(tabs, "الغرف", "rooms")
    add_tab(tabs, "الشخصيات", "characters")
    add_tab(tabs, "الإعدادات", "settings")

func add_tab(parent: GridContainer, title: String, tab_name: String):
    var btn = Button.new()
    btn.text = title
    btn.custom_minimum_size = Vector2(0, 55)
    btn.pressed.connect(func(): open_tab(tab_name))
    parent.add_child(btn)

func open_tab(tab_name: String):
    selected_tab = tab_name
    print("LOBBY SECTION: ", tab_name)

    if tab_name == "characters":
        get_tree().change_scene_to_file("res://scenes/character_select.tscn")
    elif tab_name == "settings":
        get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_play():
    print("MATCHMAKING NOT READY - WAITING FOR REAL SERVER")
