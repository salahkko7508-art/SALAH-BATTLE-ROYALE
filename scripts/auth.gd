extends Node

var player_id = ""
var player_name = "ضيف"
var player_email = ""
var is_logged_in = false
var total_players = 0
var player_rank = 0
var is_owner = false

# رقمك انت - محجوز ليك براك
var OWNER_ID = "IB 0000"

# اول 50 - ارقام مميزة زي 2005010
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

func generate_player_id():
    var numbers = ""
    player_rank = total_players + 1

    if player_rank <= 50:
        numbers = special_50[player_rank - 1]
        print("انت من اول 50! رقمك: IB ", numbers, " 👑")
    elif player_rank <= 100:
        for i in range(7):
            if i == 0:
                numbers += str(randi_range(1, 9))
            else:
                numbers += str(randi_range(0, 9))
        print("انت من اول 100! IB من 7 ارقام: IB ", numbers)
    else:
        for i in range(10):
            if i == 0:
                numbers += str(randi_range(1, 9))
            else:
                numbers += str(randi_range(0, 9))
        print("انت اللاعب رقم ", player_rank, " IB من 10 ارقام: IB ", numbers)

    player_id = "IB " + numbers
    total_players += 1
    return player_id

# دي حقتك انت بس - لما تسجل انت
func login_as_owner(email, name):
    player_email = email
    player_name = name
    player_id = OWNER_ID
    player_rank = 0
    is_owner = true
    is_logged_in = true
    print("مرحب بالمالك 👑👑👑")
    print("رقمك: ", player_id, " - ما في زول عندو زيو")
    print("عندك كل الصلاحيات: تدي كون، تحظر، تفتح كل الملابس")
    return player_id

func login_with_google(email, name):
    # لو ده ايميلك انت، اديك رقم المالك طوالي
    # غير الايميل ده لايميلك الحقيقي
    if email == "salah@gmail.com":
        return login_as_owner(email, name)
    player_email = email
    player_name = name
    is_logged_in = true
    if player_id == "":
        generate_player_id()
    print("مرحب بيك ", player_name, " ترتيبك: ", player_rank, " معرفك: ", player_id)
    return player_id

func get_my_id():
    return player_id

func is_owner_account():
    return player_id == OWNER_ID
