extends Node3D

var start_radius = 1000.0
var end_radius = 10.0
var total_time = 900.0
var current_radius = 1000.0
var elapsed = 0.0
var player: CharacterBody3D
var damage_timer = 0.0
var damage_per_sec = 2.0
var circle_mesh: MeshInstance3D
var wall_mesh: MeshInstance3D

func _ready():
	player = get_node_or_null("../Player")
	circle_mesh = MeshInstance3D.new()
	var circle = CylinderMesh.new()
	circle.top_radius = 1.0
	circle.bottom_radius = 1.0
	circle.height = 0.1
	circle.radial_segments = 64
	circle_mesh.mesh = circle
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0, 1, 0, 0.25)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	circle_mesh.material_override = mat
	add_child(circle_mesh)
	wall_mesh = MeshInstance3D.new()
	var wall_cyl = CylinderMesh.new()
	wall_cyl.top_radius = 1.0
	wall_cyl.bottom_radius = 1.0
	wall_cyl.height = 50.0
	wall_cyl.radial_segments = 64
	wall_mesh.mesh = wall_cyl
	var wall_mat = StandardMaterial3D.new()
	wall_mat.albedo_color = Color(0, 1, 0, 0.15)
	wall_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	wall_mesh.material_override = wall_mat
	wall_mesh.position.y = 25.0
	add_child(wall_mesh)
	print("ZONE LOADED - Radius: ", current_radius)

func _process(delta):
	elapsed += delta
	var t = clamp(elapsed / total_time, 0.0, 1.0)
	current_radius = lerp(start_radius, end_radius, t)
	circle_mesh.scale = Vector3(current_radius, 1, current_radius)
	wall_mesh.scale = Vector3(current_radius, 1, current_radius)
	if current_radius > 500:
		damage_per_sec = 1.0
	elif current_radius > 200:
		damage_per_sec = 2.0
	elif current_radius > 50:
		damage_per_sec = 5.0
	else:
		damage_per_sec = 10.0
	if player:
		var dist = player.global_position.distance_to(global_position)
		if dist > current_radius:
			damage_timer += delta
			if damage_timer >= 1.0:
				damage_timer = 0.0
				if player.has_method("take_damage"):
					player.take_damage(damage_per_sec)
				print("OUTSIDE ZONE! -", damage_per_sec, " HP")
