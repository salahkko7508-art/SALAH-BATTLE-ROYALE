extends SceneTree
func _init():
	var m = load("res://scripts/map.gd").new()
	m._ready()
	print("Spawn Test: ", m.get_random_spawn())
	print("Inside Check (0,0): ", m.is_inside(Vector3(0,0,0)))
	print("Outside Check (1500,0): ", m.is_inside(Vector3(1500,0,0)))
	print("MAP TEST DONE")
	quit()
