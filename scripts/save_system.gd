extends Node
const SAVE_PATH = "user://savegame.save"
func save_game():
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_var(Global.coins)
    file.store_var(Global.xp)
    file.store_var(Global.level)
    file.store_var(Global.outfit)
    file.store_var(Global.gender)
    print("تم الحفظ! قروشك: ", Global.coins)
func load_game():
    if not FileAccess.file_exists(SAVE_PATH):
        print("ما في حفظ قديم، لعبة جديدة")
        return
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    Global.coins = file.get_var()
    Global.xp = file.get_var()
    Global.level = file.get_var()
    Global.outfit = file.get_var()
    Global.gender = file.get_var()
    print("رجعنا حفظك! قروشك: ", Global.coins, " لبستك: ", Global.outfit)
