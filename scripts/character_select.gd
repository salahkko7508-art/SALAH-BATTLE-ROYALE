extends Control
func _ready():
	$SalahButton.pressed.connect(func(): Global.selected_character = "salah"; update_info())
	$EvaButton.pressed.connect(func(): Global.selected_character = "eva"; update_info())
	$OutfitClassic.pressed.connect(func(): Global.selected_outfit = "classic"; update_info())
	$OutfitSport.pressed.connect(func(): Global.selected_outfit = "sport"; update_info())
	$OutfitRoyal.pressed.connect(func(): Global.selected_outfit = "royal"; update_info())
	$OutfitStreet.pressed.connect(func(): Global.selected_outfit = "street"; update_info())
	$MapDesert.pressed.connect(func(): Global.selected_map = "desert"; update_info())
	$MapCity.pressed.connect(func(): Global.selected_map = "city"; update_info())
	$MapForest.pressed.connect(func(): Global.selected_map = "forest"; update_info())
	$W_Pistol.pressed.connect(func(): Global.selected_weapon = "pistol"; update_info())
	$W_Rifle.pressed.connect(func(): Global.selected_weapon = "rifle"; update_info())
	$W_Shotgun.pressed.connect(func(): Global.selected_weapon = "shotgun"; update_info())
	$W_Sniper.pressed.connect(func(): Global.selected_weapon = "sniper"; update_info())
	$PlayButton.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
func update_info():
	$Info.text = "اختيارك: " + Global.selected_character.to_upper() + " | " + Global.selected_outfit + " | " + Global.selected_map + " | " + Global.selected_weapon
	print($Info.text)
