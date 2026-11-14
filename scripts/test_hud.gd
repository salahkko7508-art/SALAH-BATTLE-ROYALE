extends SceneTree
func _init():
	var hud = load("res://scripts/hud.gd").new()
	hud._ready()
	print("--- Body Hit ---")
	hud.hit_body()
	print("--- Head Hit ---")
	hud.hit_head()
	print("--- Sniper Head ---")
	hud.hit_sniper_head()
	print("HUD TEST DONE")
	quit()
