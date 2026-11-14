extends Node
var houses = []
var zones = {
"Peak": Vector3(0, 0, 0),
"Pochinok": Vector3(-600, 0, 400),
"Factory": Vector3(600, 0, -400),
"Clock Tower": Vector3(-400, 0, -600),
"Bimasakti": Vector3(700, 0, 600),
"Sentosa": Vector3(-700, 0, -200)
}
func _ready():
	print("LOOT SYSTEM LOADED")
	for z in zones:
		for i in range(5):
			var pos = zones[z] + Vector3(randf_range(-80, 80), 0, randf_range(-80, 80))
			var loot = get_random_loot()
			houses.append({"zone": z, "pos": pos, "loot": loot})
			print(z, " House ", i+1, " -> ", loot)
	print("Total Houses: ", houses.size())
func get_random_loot():
	var r = randi() % 100
	if r < 40:
		return "Ammo 30"
	elif r < 60:
		return "Medkit +50 HP"
	elif r < 80:
		return "Ammo 60"
	elif r < 90:
		return "Helmet"
	else:
		return "Sniper"
func pickup_loot(index, hud):
	var h = houses[index]
	print("Picked from ", h.zone, " : ", h.loot)
	if h.loot == "Ammo 30":
		hud.pickup_ammo(30)
	elif h.loot == "Ammo 60":
		hud.pickup_ammo(60)
	elif h.loot == "Medkit +50 HP":
		hud.health = min(100, hud.health + 50)
		print("Healed - Health: ", hud.health)
