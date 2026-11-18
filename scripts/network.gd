extends Node
const MAX_PLAYERS = 49
const PORT = 7777
const DB_URL = "https://salah-battle-royale-default-rtdb.firebaseio.com"
var players = {}
var http: HTTPRequest
var http_list: HTTPRequest
var my_room_code = ""
var my_name = "Player"
var is_host = false
signal rooms_listed(rooms: Array)
signal room_created(code: String)
signal room_joined(code: String)
func _ready():
	print("NETWORK LOADED - FIREBASE ROOMS")
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_http_done)
	http_list = HTTPRequest.new()
	add_child(http_list)
	http_list.request_completed.connect(_on_list_done)
func set_player_name(n: String):
	my_name = n
func create_room(room_name: String = "Room"):
	is_host = true
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err != OK:
		print("SERVER ERROR: ", err)
		return ""
	multiplayer.multiplayer_peer = peer
	print("SERVER STARTED ON PORT ", PORT)
	add_player(1)
	my_room_code = str(randi_range(1000, 9999))
	var data = {"code": my_room_code, "name": room_name, "host_name": my_name, "port": PORT, "players": 1, "max_players": MAX_PLAYERS, "created": Time.get_unix_time_from_system(), "ip": "41.95.218.169"}
	var url = DB_URL + "/rooms/" + my_room_code + ".json"
	http.request(url, PackedStringArray(["Content-Type: application/json"]), HTTPClient.METHOD_PUT, JSON.stringify(data))
	room_created.emit(my_room_code)
	return my_room_code
func list_rooms():
	var url = DB_URL + "/rooms.json"
	http_list.request(url)
func _on_list_done(result, code, _headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	var out: Array = []
	if data is Dictionary:
		for k in data.keys():
			var r = data[k]
			if r is Dictionary:
				r["code"] = k
				out.append(r)
	rooms_listed.emit(out)
	print("ROOMS: ", out.size())
func _on_http_done(result, code, _headers, body):
	print("FIREBASE ROOM SAVED: ", code)
func join_room_by_code(room_code: String, ip: String, port: int = 7777):
	join_game(ip, port)
	room_joined.emit(room_code)
func join_game(ip: String, port: int = 7777):
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, port)
	if err != OK:
		print("CLIENT ERROR: ", err)
		return
	multiplayer.multiplayer_peer = peer
	print("JOINING SERVER: ", ip, ":", port)
func host_game():
	create_room("SALAH Room")
func _on_player_connected(id):
	if not multiplayer.is_server():
		return
	print("PLAYER CONNECTED: ", id)
	var existing_ids = players.keys()
	for eid in existing_ids:
			rpc_id(id, "add_player", eid)
	rpc("add_player", id)
func _on_player_disconnected(id):
	if multiplayer.is_server():
		print("PLAYER DISCONNECTED: ", id)
		rpc("remove_player", id)
func _on_connected_to_server():
	print("CONNECTED TO SERVER!")
func _on_connection_failed():
	print("CONNECTION FAILED!")
@rpc("authority", "call_local", "reliable")
func add_player(id):
	if players.has(id):
		return
	var p = CharacterBody3D.new()
	p.name = str(id)
	p.set_multiplayer_authority(id)
	p.set_script(load("res://scripts/mp_player.gd"))
	p.position = Vector3(id * 2, 1, 0)
	get_tree().root.add_child(p)
	players[id] = p
	print("PLAYER SPAWNED: ", id)
@rpc("authority", "call_local", "reliable")
func remove_player(id):
	if not players.has(id):
		return
	players[id].queue_free()
	players.erase(id)
	print("PLAYER REMOVED: ", id)
