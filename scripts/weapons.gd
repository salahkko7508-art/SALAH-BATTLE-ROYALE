extends Control
func _ready():
    $BackButton.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/lobby.tscn"))
    $BuyButton.pressed.connect(func(): $Msg.text = "✅ تم! رجعت للوبي...")
