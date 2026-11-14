extends CanvasLayer
var hp_label: Label
var zone_label: Label
var time_label: Label
var alive_label: Label
var player: CharacterBody3D
var zone: Node3D
func _ready():
	player = get_node_or_null("../Player")
	zone = get_node_or_null("../Zone")
	hp_label = Label.new()
	hp_label.position = Vector2(20, 20)
	hp_label.add_theme_font_size_override("font_size", 28)
	add_child(hp_label)
	zone_label = Label.new()
	zone_label.position = Vector2(20, 60)
	zone_label.add_theme_font_size_override("font_size", 24)
	add_child(zone_label)
	time_label = Label.new()
	time_label.position = Vector2(20, 100)
	time_label.add_theme_font_size_override("font_size", 24)
	add_child(time_label)
	alive_label = Label.new()
	alive_label.position = Vector2(20, 140)
	alive_label.add_theme_font_size_override("font_size", 24)
	add_child(alive_label)
	print("HUD LOADED")
func _process(_delta):
	if player:
		var hp = player.get("hp")
		hp_label.text = "HP: " + str(int(hp)) + " / 100"
	if zone:
		var r = zone.get("current_radius")
		var t = zone.get("total_time") - zone.get("elapsed")
		var mins = int(t / 60)
		var secs = int(t) % 60
		zone_label.text = "ZONE: " + str(int(r)) + "m"
		time_label.text = "TIME: " + str(mins) + ":" + str(secs)
		alive_label.text = "ALIVE: 1"
