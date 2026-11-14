extends Node
var PORT = 7777
var players = {}
func _ready():
	print("NETWORK LOADED")
	multiplayer.peer_connected.connect(_on_player_connected)
func host_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 32)
	multiplayer.multiplayer_peer = peer
	print("SERVER STARTED ON PORT " + str(PORT))
	spawn_player(1)
func join_game(ip):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	print("JOINING " + ip)
func _on_player_connected(id):
	print("PLAYER CONNECTED " + str(id))
	spawn_player(id)
func spawn_player(id):
	var p = CharacterBody3D.new()
	p.name = str(id)
	p.set_multiplayer_authority(id)
	p.set_script(load("res://scripts/mp_player.gd"))
	p.position = Vector3(id * 2, 1, 0)
	get_tree().current_scene.add_child(p)
