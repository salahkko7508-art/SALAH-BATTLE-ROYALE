extends SceneTree
func _init():
    var voice = load("res://scripts/voice_chat.gd").new()
    print(voice.get_status())
    voice.toggle_mic()
    print(voice.get_status())
    voice.toggle_speaker()
    print(voice.get_status())
    voice.unmute_all()
    print(voice.get_status())
    print("ظبط!")
    quit()
