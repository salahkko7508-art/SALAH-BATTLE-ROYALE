extends Node3D
var bullets = []
func _ready():
	print("WEAPON LOADED")
	var gun = MeshInstance3D.new()
	gun.mesh = BoxMesh.new()
	gun.mesh.size = Vector3(0.2, 0.2, 1.0)
	var m = StandardMaterial3D.new()
	m.albedo_color = Color(0.1, 0.1, 0.1)
	gun.material_override = m
	gun.position = Vector3(0.4, -0.3, -0.8)
	add_child(gun)
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("PEW SHOOT")
		var b = MeshInstance3D.new()
		b.mesh = SphereMesh.new()
		b.mesh.radius = 0.15
		var bm = StandardMaterial3D.new()
		bm.albedo_color = Color(1, 0.9, 0)
		b.material_override = bm
		b.global_position = global_position + Vector3(0, -0.2, -1)
		get_tree().current_scene.add_child(b)
		bullets.append(b)
func _process(delta):
	for b in bullets:
		b.global_position += Vector3(0, 0, -1) * 30 * delta
