extends Node

var player_id = ""
var player_name = "ضيف"
var player_email = ""
var player_avatar_url = ""
var firebase_uid = ""
var is_logged_in = false
var total_players = 0
var player_rank = 0
var is_owner = false

var player_level = 1
var player_xp = 0
var name_change_used = false

const OWNER_ID = "IB 0000"
const PROFILE_PATH = "user://player_profile.cfg"

var special_50 = [
    "2005010", "2005011", "2005012", "2010010", "2010011",
    "2007007", "2008008", "2009009", "2012020", "2013030",
    "1111111", "2222222", "7777777", "8888888", "9999999",
    "1000001", "1000007", "2000002", "3000003", "5000005",
    "1234567", "7654321", "1020304", "1122334", "1212121",
    "2001010", "2002020", "2003030", "2004040", "2005050",
    "2010101", "2020202", "2030303", "1010101", "2020201",
    "7000007", "8000008", "9000009", "6000006", "4000004",
    "1233210", "1001001", "2002002", "3003003", "5005005",
    "7770007", "1110001", "2220002", "5550005", "9990009"
]

func _ready():
    load_profile()

func generate_player_id():
    var numbers = ""
    player_rank = total_players + 1

    if player_rank <= 50:
        numbers = special_50[player_rank - 1]
        print("رقم مميز: IB ", numbers)
    else:
        for i in range(10):
            if i == 0:
                numbers += str(randi_range(1, 9))
            else:
                numbers += str(randi_range(0, 9))

    player_id = "IB " + numbers
    total_players += 1
    save_profile()
    return player_id

func login_as_owner(email, name):
    player_email = email
    player_name = name
    player_id = OWNER_ID
    player_rank = 0
    is_owner = true
    is_logged_in = true
    save_profile()
    print("مرحب بالمالك")
    print("رقمك: ", player_id)
    return player_id

func login_with_google(email, name, avatar_url: String = ""):
    if email == "salah@gmail.com":
        return login_as_owner(email, name)

    player_email = email
    player_name = name
    is_logged_in = true
    player_avatar_url = avatar_url

    if player_id == "":
        generate_player_id()

    save_profile()
    print("مرحب بيك ", player_name, " - ", player_id)
    return player_id

func login_with_firebase(data: Dictionary) -> bool:
    var received_uid = str(data.get("localId", "")).strip_edges()
    var received_email = str(data.get("email", "")).strip_edges()

    if received_uid.is_empty():
        print("FIREBASE LOGIN ERROR: UID MISSING")
        return false

    if not firebase_uid.is_empty() and firebase_uid != received_uid:
        print("FIREBASE SWITCHING ACCOUNT")
        player_id = ""
        player_name = "ضيف"
        player_level = 1
        player_xp = 0
        name_change_used = false

    firebase_uid = received_uid
    player_email = received_email
    var disp = str(data.get("displayName", "")).strip_edges()
    if not disp.is_empty():
        player_name = disp
    is_owner = false

    if player_id.is_empty():
        if player_name == "ضيف" and not received_email.is_empty():
            player_name = received_email.get_slice("@", 0)
        if player_name.is_empty():
            player_name = "لاعب"
        generate_player_id()

    is_logged_in = true
    save_profile()
    print("FIREBASE PLAYER PROFILE LINKED")
    return true


func change_player_name(new_name: String) -> bool:
    new_name = new_name.strip_edges()

    if player_level < 5:
        print("تغيير الاسم متاح من المستوى 5")
        return false

    if name_change_used:
        print("لقد استخدمت فرصة تغيير الاسم")
        return false

    if new_name.is_empty() or new_name.length() < 3 or new_name.length() > 16:
        print("الاسم يجب أن يكون من 3 إلى 16 حرفاً")
        return false

    player_name = new_name
    name_change_used = true
    save_profile()

    print("تم تغيير الاسم بنجاح")
    print("ID الخاص بك لم يتغير: ", player_id)
    return true

func add_xp(amount: int):
    if amount <= 0:
        return

    player_xp += amount

    while player_xp >= player_level * 100:
        player_xp -= player_level * 100
        player_level += 1
        print("وصلت للمستوى: ", player_level)

    save_profile()

func save_profile():
    var config = ConfigFile.new()
    config.set_value("player", "id", player_id)
    config.set_value("player", "name", player_name)
    config.set_value("player", "email", player_email)
    config.set_value("player", "firebase_uid", firebase_uid)
    config.set_value("player", "level", player_level)
    config.set_value("player", "xp", player_xp)
    config.set_value("player", "rank", player_rank)
    config.set_value("player", "name_change_used", name_change_used)
    config.set_value("player", "is_owner", is_owner)
    config.save(PROFILE_PATH)

func load_profile():
    var config = ConfigFile.new()
    var error = config.load(PROFILE_PATH)

    if error != OK:
        return

    player_id = config.get_value("player", "id", "")
    player_name = config.get_value("player", "name", "ضيف")
    player_email = config.get_value("player", "email", "")
    firebase_uid = config.get_value("player", "firebase_uid", "")
    player_level = config.get_value("player", "level", 1)
    player_xp = config.get_value("player", "xp", 0)
    player_rank = config.get_value("player", "rank", 0)
    name_change_used = config.get_value("player", "name_change_used", false)
    is_owner = config.get_value("player", "is_owner", false)
    is_logged_in = player_id != ""

func logout():
    player_id = ""
    player_name = "ضيف"
    player_email = ""
    firebase_uid = ""
    player_avatar_url = ""
    is_logged_in = false
    is_owner = false
    player_level = 1
    player_xp = 0
    save_profile()
    print("LOGGED OUT")
    return true

func get_my_id():
    return player_id

func is_owner_account():
    return player_id == OWNER_ID

func login_as_guest():
    if player_id == "":
        player_name = "ضيف"
        is_owner = false
        generate_player_id()

    is_logged_in = true
    save_profile()

    print("تم الدخول كضيف")
    print("اسم اللاعب: ", player_name)
    print("رقم اللاعب: ", player_id)

    return player_id
