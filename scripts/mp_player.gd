extends CharacterBody3D
var SPEED = 8.0
func _ready():
	var my_id = get_multiplayer_authority()
	var char_index = my_id % 2
	build_character(char_index)
	if is_multiplayer_authority():
		var cam = Camera3D.new()
		cam.position = Vector3(0, 1.6, 0)
		add_child(cam)
		cam.current = true
func build_character(index):
	var skin = StandardMaterial3D.new()
	skin.albedo_color = Color(0.9, 0.7, 0.5)
	var head = MeshInstance3D.new()
	head.mesh = SphereMesh.new()
	head.mesh.radius = 0.3
	head.position = Vector3(0, 1.5, 0)
	head.material_override = skin
	add_child(head)
	var shirt_mat = StandardMaterial3D.new()
	var pants_mat = StandardMaterial3D.new()
	var hair = MeshInstance3D.new()
	hair.mesh = SphereMesh.new()
	hair.mesh.radius = 0.32
	hair.position = Vector3(0, 1.65, 0)
	if index == 0:
		shirt_mat.albedo_color = Color(0, 0.3, 0.9)
		pants_mat.albedo_color = Color(0.1, 0.1, 0.1)
		hair.material_override = StandardMaterial3D.new()
		hair.material_override.albedo_color = Color(0.1, 0.1, 0.1)
		print("CHARACTER SALAH")
	if index == 1:
		shirt_mat.albedo_color = Color(1, 0.4, 0.6)
		pants_mat.albedo_color = Color(1, 1, 1)
		hair.material_override = StandardMaterial3D.new()
		hair.material_override.albedo_color = Color(0.4, 0.2, 0)
		hair.scale = Vector3(1, 1.2, 1)
		print("CHARACTER EVA")
	add_child(hair)
	var body = MeshInstance3D.new()
	body.mesh = BoxMesh.new()
	body.mesh.size = Vector3(0.6, 0.7, 0.35)
	body.position = Vector3(0, 0.8, 0)
	body.material_override = shirt_mat
	add_child(body)
	var legs = MeshInstance3D.new()
	legs.mesh = BoxMesh.new()
	legs.mesh.size = Vector3(0.5, 0.6, 0.3)
	legs.position = Vector3(0, 0.15, 0)
	legs.material_override = pants_mat
	add_child(legs)
func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	var dir = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		dir.z -= 1
	if Input.is_key_pressed(KEY_S):
		dir.z += 1
	if Input.is_key_pressed(KEY_A):
		dir.x -= 1
	if Input.is_key_pressed(KEY_D):
		dir.x += 1
	velocity = dir.normalized() * SPEED
	move_and_slide()
