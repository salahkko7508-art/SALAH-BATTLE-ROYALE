extends Node
func _ready():
    var net = load("res://scripts/network.gd").new()
    add_child(net)
    await get_tree().process_frame
    net.host_game()
    print("DEDICATED SERVER RUNNING ON 7777 - READY")
