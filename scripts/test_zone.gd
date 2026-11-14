extends SceneTree
func _init():
	var zone = load("res://scripts/zone.gd").new()
	zone._ready()
	print("Total Waits: ", zone.waits[0] + zone.waits[1] + zone.waits[2] + zone.waits[3] + zone.waits[4], " sec")
	print("Total Shrinks: ", zone.shrink_times[0] + zone.shrink_times[1] + zone.shrink_times[2] + zone.shrink_times[3] + zone.shrink_times[4], " sec")
	print("Total = 900 sec = 15 MIN")
	print("Player at 0 Inside? ", zone.is_inside_zone(Vector3(0,0,0)))
	print("Player at 1500 Inside? ", zone.is_inside_zone(Vector3(1500,0,0)))
	var hud = load("res://scripts/hud.gd").new()
	hud.health = 100
	zone.zone_damage(Vector3(1500,0,0), hud, 1.0)
	print("Health after 1 sec outside Phase 1 (Damage 2): ", hud.health)
	print("ZONE 15 MIN TEST DONE")
	quit()
