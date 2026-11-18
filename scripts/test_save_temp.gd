extends SceneTree

func _initialize():
    call_deferred("_run_test")

func _run_test():
    var g = root.get_node_or_null("Global")
    var s = root.get_node_or_null("SaveSystem")

    if g == null or s == null:
        print("TEST FAILED: AUTOLOAD NOT FOUND")
        quit()
        return

    var original = {
        "character": g.selected_character,
        "outfit": g.selected_outfit,
        "map": g.selected_map,
        "weapon": g.selected_weapon,
        "level": g.player_level,
        "xp": g.player_xp,
        "kills": g.player_kills
    }

    s.save_game()

    g.selected_character = "TEST"
    g.selected_outfit = "TEST"
    g.selected_map = "TEST"
    g.selected_weapon = "TEST"
    g.player_level = -1
    g.player_xp = -1
    g.player_kills = -1

    s.load_game()

    var passed = (
        g.selected_character == original.character
        and g.selected_outfit == original.outfit
        and g.selected_map == original.map
        and g.selected_weapon == original.weapon
        and g.player_level == original.level
        and g.player_xp == original.xp
        and g.player_kills == original.kills
    )

    print("SAVE AND LOAD TEST: ", "PASS" if passed else "FAIL")
    quit()
