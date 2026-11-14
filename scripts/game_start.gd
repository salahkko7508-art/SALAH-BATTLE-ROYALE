extends Node

# أول ما تدخل اللعبة
var first_time = true
var current_character = "salah" # دايما صلاح في البداية
var characters_unlocked = ["salah"] # في البداية عندك صلاح بس

var characters_data = {
    "salah": {
        "name": "Salah",
        "arabic": "صلاح",
        "outfit": "بجامة بوما سودة + جزمة بيضة",
        "locked": false,
        "is_default": true
    },
    "eva": {
        "name": "Eva",
        "arabic": "إيفا",
        "outfit": "بنطلون ابيض + بلوزة سودة + شعر لي الكتف",
        "locked": false, # بتفتح ليك مجان عشان تغير ليها
        "is_default": false
    }
}

# أول ما تفتح اللعبة
func start_game():
    if not FileAccess.file_exists("user://save_game.save"):
        # دي أول مرة تدخل
        print("مرحب بيك أول مرة! 🙏")
        print("شخصيتك: صلاح 👦")
        print("اللبس: بجامة بوما سودة + جزمة بيضة")
        current_character = "salah"
        first_time = true
        save_game()
        return "salah"
    else:
        # ما أول مرة - رجع شخصيتك الاخترتها اخر مرة
        load_game()
        print("رجعت ليك تاني! شخصيتك: ", characters_data[current_character].arabic)
        return current_character

# خانة الشخصيات - هنا بتغير
func open_characters_menu():
    print("=== خانة الشخصيات ===")
    print("شخصيتك هسي: ", characters_data[current_character].arabic)
    print("1 - صلاح 👦 - بجامة بوما سودة + جزمة بيضة")
    print("2 - إيفا 👧 - بنطلون ابيض + بلوزة سودة")
    print("اختار رقم عشان تغير")
    return characters_data

# غير من خانة الشخصيات بس
func change_character_from_menu(new_char):
    if new_char == "salah" or new_char == "eva":
        current_character = new_char
        print("غيرت لي: ", characters_data[new_char].arabic, " ✅")
        print("اللبس: ", characters_data[new_char].outfit)
        save_game()
        return true
    else:
        print("ما في شخصية بالاسم ده")
        return false

func get_current_character():
    return characters_data[current_character]

func save_game():
    var file = FileAccess.open("user://save_game.save", FileAccess.WRITE)
    file.store_string(current_character)
    file.close()

func load_game():
    var file = FileAccess.open("user://save_game.save", FileAccess.READ)
    current_character = file.get_as_text()
    file.close()
    return current_character
