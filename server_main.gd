extends SceneTree
var net
var started = false
func _initialize():
    net = load("res://scripts/network.gd").new()
    root.add_child(net)
    return true
func _process(delta):
    if not started:
        started = true
        net.host_game()
        print("DEDICATED SERVER RUNNING ON 7777")
    return true
