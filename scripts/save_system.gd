extends Node

func get_save_path() -> String:
	if Auth.firebase_uid != "":
		return "user://save_" + Auth.firebase_uid + ".cfg"
	return "user://player_save.cfg"

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
	config.set_value("player", "coins", Global.coins)
	config.set_value("player", "diamonds", Global.diamonds)
	config.set_value("player", "owned_skins", Global.owned_skins)
	config.set_value("player", "owned_weapons", Global.owned_weapons)
	config.set_value("player", "purchases", Global.purchases)
	var error = config.save(get_save_path())
	if error == OK:
		print("PLAYER DATA SAVED")
	else:
		push_error("SAVE FAILED: " + str(error))

func load_game():
	if not FileAccess.file_exists(get_save_path()):
		print("NEW PLAYER: NO SAVE FOUND")
		return
	var config = ConfigFile.new()
	var error = config.load(get_save_path())
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
	Global.coins = config.get_value("player", "coins", 0)
	Global.diamonds = config.get_value("player", "diamonds", 0)
	Global.owned_skins = config.get_value("player", "owned_skins", ["classic"])
	Global.owned_weapons = config.get_value("player", "owned_weapons", ["rifle"])
	Global.purchases = config.get_value("player", "purchases", [])
	print("PLAYER DATA LOADED")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		save_game()
