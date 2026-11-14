extends CanvasLayer
func _ready():
	print("LOBBY LOADED")
	var host_btn = Button.new()
	host_btn.text = "HOST SERVER"
	host_btn.position = Vector2(100, 100)
	host_btn.size = Vector2(300, 80)
	host_btn.pressed.connect(_on_host)
	add_child(host_btn)
	var join_btn = Button.new()
	join_btn.text = "JOIN 127.0.0.1"
	join_btn.position = Vector2(100, 200)
	join_btn.size = Vector2(300, 80)
	join_btn.pressed.connect(_on_join)
	add_child(join_btn)
func _on_host():
	get_node("/root/Main/Network").host_game()
	print("HOST CLICKED")
	visible = false
func _on_join():
	get_node("/root/Main/Network").join_game("127.0.0.1")
	print("JOIN CLICKED")
	visible = false
