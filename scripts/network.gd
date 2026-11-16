extends Node

const PORT = 7777
const MAX_PLAYERS = 49

var players = {}

func _ready():
    print("NETWORK LOADED")
    multiplayer.peer_connected.connect(_on_player_connected)
    multiplayer.peer_disconnected.connect(_on_player_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)

func host_game():
    var peer = ENetMultiplayerPeer.new()
    var error = peer.create_server(PORT, MAX_PLAYERS)

    if error != OK:
        print("SERVER ERROR: ", error)
        return

    multiplayer.multiplayer_peer = peer
    print("SERVER STARTED ON PORT ", PORT)
    add_player(1)

func join_game(ip):
    var peer = ENetMultiplayerPeer.new()
    var error = peer.create_client(ip, PORT)

    if error != OK:
        print("CLIENT ERROR: ", error)
        return

    multiplayer.multiplayer_peer = peer
    print("JOINING SERVER: ", ip)

func _on_player_connected(id):
    if not multiplayer.is_server():
        return

    print("PLAYER CONNECTED: ", id)

    var existing_ids = players.keys()

    for existing_id in existing_ids:
        rpc_id(id, "add_player", existing_id)

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

    get_tree().current_scene.add_child(p)
    players[id] = p

    print("PLAYER SPAWNED: ", id)

@rpc("authority", "call_local", "reliable")
func remove_player(id):
    if not players.has(id):
        return

    players[id].queue_free()
    players.erase(id)
    print("PLAYER REMOVED: ", id)
