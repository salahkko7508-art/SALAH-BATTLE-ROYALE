extends Node

const SAVE_PATH = "user://player_save.cfg"

func _ready():
    load_game()

func save_game():
    var config = ConfigFile.new()

    config.set_value("player", "selected_character", Global.selected_character)
    config.set_value("player", "selected_outfit", Global.selected_outfit)
    config.set_value("player", "selected_map", Global.selected_map)
    config.set_value("player", "selected_weapon", Global.selected_weapon)
    config.set_value("player", "player_level", Global.player_level)
    config.set_value("player", "player_xp", Global.player_xp)
    config.set_value("player", "player_kills", Global.player_kills)

    var error = config.save(SAVE_PATH)
    if error == OK:
        print("PLAYER DATA SAVED")
    else:
        push_error("SAVE FAILED: " + str(error))

func load_game():
    if not FileAccess.file_exists(SAVE_PATH):
        print("NEW PLAYER: NO SAVE FOUND")
        return

    var config = ConfigFile.new()
    var error = config.load(SAVE_PATH)

    if error != OK:
        push_error("LOAD FAILED: " + str(error))
        return

    Global.selected_character = config.get_value("player", "selected_character", Global.selected_character)
    Global.selected_outfit = config.get_value("player", "selected_outfit", Global.selected_outfit)
    Global.selected_map = config.get_value("player", "selected_map", Global.selected_map)
    Global.selected_weapon = config.get_value("player", "selected_weapon", Global.selected_weapon)
    Global.player_level = config.get_value("player", "player_level", Global.player_level)
    Global.player_xp = config.get_value("player", "player_xp", Global.player_xp)
    Global.player_kills = config.get_value("player", "player_kills", Global.player_kills)

    print("PLAYER DATA LOADED")

func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
        save_game()
