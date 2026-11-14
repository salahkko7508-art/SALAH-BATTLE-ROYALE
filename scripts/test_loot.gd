extends SceneTree
func _init():
	var loot = load("res://scripts/loot.gd").new()
	loot._ready()
	var hud = load("res://scripts/hud.gd").new()
	loot.pickup_loot(0, hud)
	loot.pickup_loot(1, hud)
	print("LOOT TEST DONE")
	quit()
