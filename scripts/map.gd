extends Node3D
func _ready():
	print("MAP LOADED - 1 HOUSE")
	var h = MeshInstance3D.new()
	var m = StandardMaterial3D.new()
	m.albedo_color = Color(0.8, 0.7, 0.5)
	h.mesh = BoxMesh.new()
	h.mesh.size = Vector3(8, 4, 8)
	h.material_override = m
	h.position = Vector3(10, 2, -10)
	add_child(h)
	var roof = MeshInstance3D.new()
	var m2 = StandardMaterial3D.new()
	m2.albedo_color = Color(0.8, 0.2, 0.2)
	roof.mesh = BoxMesh.new()
	roof.mesh.size = Vector3(9, 0.5, 9)
	roof.material_override = m2
	roof.position = Vector3(10, 4.2, -10)
	add_child(roof)
	var trunk = MeshInstance3D.new()
	var mt = StandardMaterial3D.new()
	mt.albedo_color = Color(0.4, 0.25, 0.1)
	trunk.mesh = CylinderMesh.new()
	trunk.mesh.height = 3
	trunk.material_override = mt
	trunk.position = Vector3(-10, 1.5, -10)
	add_child(trunk)
	var leaves = MeshInstance3D.new()
	var ml = StandardMaterial3D.new()
	ml.albedo_color = Color(0.1, 0.6, 0.1)
	leaves.mesh = SphereMesh.new()
	leaves.mesh.radius = 2
	leaves.material_override = ml
	leaves.position = Vector3(-10, 4.5, -10)
	add_child(leaves)
