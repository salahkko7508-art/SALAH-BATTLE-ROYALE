extends Node3D
var current_character = "salah"
func _ready():
	print("MAP LOADING")
	print("Your Character: ", current_character)
	var ground = MeshInstance3D.new()
	var gbox = BoxMesh.new()
	gbox.size = Vector3(200, 1, 200)
	ground.mesh = gbox
	ground.position = Vector3(0, -0.5, 0)
	add_child(ground)
	print("Ground Created")
	for i in range(5):
		var house = MeshInstance3D.new()
		var hbox = BoxMesh.new()
		hbox.size = Vector3(10, 6, 10)
		house.mesh = hbox
		house.position = Vector3(i * 25 - 40, 3, 20)
		add_child(house)
	print("5 Houses Created")
	for i in range(20):
		var tree = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.height = 4
		tree.mesh = cyl
		tree.position = Vector3(randf_range(-90, 90), 2, randf_range(-90, 90))
		add_child(tree)
	print("20 Trees Created")
	var player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 2, 0)
	add_child(player)
	print("Player Spawned: ", current_character)
	print("MAP DONE")
