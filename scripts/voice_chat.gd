extends Node

# المايك حقك انت
var mic_on = true
# السماعة حقتك انت - بتسمع زملائك ولا لا
var speaker_on = true

# === المايك ===
func turn_on_mic():
    mic_on = true
    print("المايك فتح 🎤 - زميلك بيسمعك هسي")
    return true

func turn_off_mic():
    mic_on = false
    print("المايك قفل 🔇 - زميلك ما بيسمعك")
    return false

func toggle_mic():
    if mic_on:
        turn_off_mic()
    else:
        turn_on_mic()
    return mic_on

# === السماعة ===
func turn_on_speaker():
    speaker_on = true
    print("السماعة فتحت 🔊 - بتسمع زميلك هسي")
    return true

func turn_off_speaker():
    speaker_on = false
    print("السماعة قفلت 🔇 - ما بتسمع زميلك")
    return false

func toggle_speaker():
    if speaker_on:
        turn_off_speaker()
    else:
        turn_on_speaker()
    return speaker_on

# === اقفل الاتنين مع بعض - لو داير تركيز ===
func mute_all():
    mic_on = false
    speaker_on = false
    print("قفلت كلو 🔇🔇 - لا بتتكلم لا بتسمع")

func unmute_all():
    mic_on = true
    speaker_on = true
    print("فتحت كلو 🎤🔊 - بتتكلم وبتسمع")

# === تتكلم مع زميلك ===
func send_voice_to_teammate(teammate_id):
    if not mic_on:
        print("المايك مقفول! افتحو اول")
        return
    if not speaker_on:
        print("انت بتتكلم لكن ما بتسمع ردو - السماعة مقفولة")
    print("بتتكلم مع: ", teammate_id, " 🎤")

func get_status():
    var mic_txt = "🎤 فاتح" if mic_on else "🔇 مقفول"
    var spk_txt = "🔊 فاتحة" if speaker_on else "🔇 مقفولة"
    return "المايك: " + mic_txt + " | السماعة: " + spk_txt
