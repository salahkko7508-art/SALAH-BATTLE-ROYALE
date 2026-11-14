extends SceneTree
func _init():
    var game = load("res://scripts/game_start.gd").new()
    print("--- أول دخول ---")
    var first = game.start_game()
    print("شخصيتك: ", first)
    print("--- دخل خانة الشخصيات ---")
    game.open_characters_menu()
    print("--- غير لي إيفا ---")
    game.change_character_from_menu("eva")
    print("--- طلع ودخل تاني ---")
    var second = game.start_game()
    print("شخصيتك هسي: ", second)
    quit()
