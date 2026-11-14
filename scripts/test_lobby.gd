extends SceneTree
func _init():
    var lobby = load("res://scripts/lobby.gd").new()
    lobby._ready()
    print("--- Pressed Characters Button ---")
    lobby._on_characters_button_pressed()
    print("--- Selected Eva ---")
    lobby._on_select_eva_pressed()
    print("--- Pressed Characters Again ---")
    lobby._on_characters_button_pressed()
    print("--- Back to Salah ---")
    lobby._on_select_salah_pressed()
    print("DONE!")
    quit()
