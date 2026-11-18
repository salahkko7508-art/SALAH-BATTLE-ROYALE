extends Control
func _ready():
	connect_btn("LeftMenu/BtnStore", "store")
	connect_btn("LeftMenu/BtnLuck", "luck")
	connect_btn("LeftMenu/BtnRank", "rank")
	connect_btn("LeftMenu/BtnMissions", "missions")
	connect_btn("LeftMenu/BtnEvents", "events")
	connect_btn("BottomBar/BtnVault", "vault")
	connect_btn("BottomBar/BtnWeapons", "weapons")
	connect_btn("BottomBar/BtnPreset", "preset")
	connect_btn("BottomBar/BtnLab", "lab")
	connect_btn("BottomBar/BtnStart", "main")
	connect_btn("TopRight/BtnSettings", "settings")
	connect_btn("TopRight/BtnMail", "mail")
	connect_btn("TopRight/BtnFriendsTop", "friends")
	connect_btn("RightFriends/F1", "friends")
	connect_btn("RightFriends/F2", "friends")
	connect_btn("RightFriends/F3", "friends")
	connect_btn("RightFriends/F4", "friends")
func connect_btn(path: String, scene: String):
	var b = get_node_or_null(path)
	if b is Button:
		b.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn"))
