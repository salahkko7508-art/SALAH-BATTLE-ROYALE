extends Node3D
@export var bot_scene: PackedScene
@export var bot_count = 10
@export var spawn_area = 40.0
func _ready():
    await get_tree().create_timer(1.0).timeout
    spawn_bots()
func spawn_bots():
    if bot_scene == null:
        print("اربط Bot.tscn في Spawner!")
        return
    for i in range(bot_count):
        var bot = bot_scene.instantiate()
        bot.global_position = Vector3(randf_range(-spawn_area, spawn_area), 1.0, randf_range(-spawn_area, spawn_area))
        add_child(bot)
    print("نزلنا ", bot_count, " بوت 🔥")
