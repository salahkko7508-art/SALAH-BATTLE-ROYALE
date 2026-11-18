extends Node

signal auth_completed(success: bool, data: Dictionary)

const FirebaseConfig = preload("res://scripts/firebase_config.gd")

var http: HTTPRequest
var http2: HTTPRequest
var pending_action = ""
var google_code = ""
var tcp_server: TCPServer
var google_waiting = false

func _ready():
    http = HTTPRequest.new()
    http.timeout = 20.0
    add_child(http)
    http.request_completed.connect(_on_request_completed)
    http2 = HTTPRequest.new()
    http2.timeout = 20.0
    add_child(http2)
    http2.request_completed.connect(_on_token_completed)
    print("FIREBASE CLIENT READY")

func create_account(email: String, password: String):
    var payload = {"email": email.strip_edges(), "password": password, "returnSecureToken": true}
    _send_auth_request("signup", "accounts:signUp", payload)

func sign_in(email: String, password: String):
    var payload = {"email": email.strip_edges(), "password": password, "returnSecureToken": true}
    _send_auth_request("login", "accounts:signInWithPassword", payload)

func start_google_sign_in():
    tcp_server = TCPServer.new()
    var err = tcp_server.listen(8080, "127.0.0.1")
    if err != OK:
        print("TCP LISTEN FAILED: ", err)
        auth_completed.emit(false, {"message": "تعذر فتح منفذ قوقل، أعد المحاولة"})
        return
    google_waiting = true
    var redirect = "http://127.0.0.1:8080"
    var url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + FirebaseConfig.GOOGLE_WEB_CLIENT_ID + "&redirect_uri=" + redirect.uri_encode() + "&response_type=code&scope=" + "openid email profile".uri_encode() + "&access_type=offline&prompt=select_account"
    print("OPEN GOOGLE URL: ", url)
    OS.shell_open(url)

func _process(_delta):
    if not google_waiting or tcp_server == null:
        return
    if tcp_server.is_connection_available():
        var peer = tcp_server.take_connection()
        var req = peer.get_utf8_string(peer.get_available_bytes())
        print("GOOGLE CALLBACK: ", req.substr(0, 300))
        # نرسل صفحة نجاح للمتصفح
        var html = "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\n\r\n<html><body><h1>تم! ارجع للعبة</h1></body></html>"
        peer.put_data(html.to_utf8_buffer())
        peer.disconnect_from_host()
        tcp_server.stop()
        google_waiting = false
        # استخرج code=
        var code = ""
        var qpos = req.find("?code=")
        if qpos != -1:
            var start = qpos + 6
            var end = req.find(" ", start)
            var query = req.substr(start, end - start)
            # اقطع عند & او مسافة
            var amp = query.find("&")
            if amp != -1:
                query = query.substr(0, amp)
            code = query.uri_decode()
        if code.is_empty():
            auth_completed.emit(false, {"message": "لم يتم الحصول على رمز قوقل"})
            return
        google_code = code
        _exchange_code(code)

func _exchange_code(code: String):
    pending_action = "google_token"
    var redirect = "http://127.0.0.1:8080"
    var body = "client_id=" + FirebaseConfig.GOOGLE_WEB_CLIENT_ID.uri_encode() + "&code=" + code.uri_encode() + "&grant_type=authorization_code&redirect_uri=" + redirect.uri_encode()
    var headers = PackedStringArray(["Content-Type: application/x-www-form-urlencoded"])
    http2.request("https://oauth2.googleapis.com/token", headers, HTTPClient.METHOD_POST, body)

func _on_token_completed(result, response_code, _headers, body):
    var data = JSON.parse_string(body.get_string_from_utf8())
    if not data is Dictionary:
        data = {}
    if result != HTTPRequest.RESULT_SUCCESS or response_code != 200 or not data.has("id_token"):
        print("GOOGLE TOKEN FAILED: ", data)
        auth_completed.emit(false, {"message": "فشل تبديل رمز قوقل"})
        return
    var id_token = str(data["id_token"])
    # دخول Firebase بـ id_token حق قوقل
    pending_action = "google_login"
    var url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=" + FirebaseConfig.API_KEY
    var payload = {
        "postBody": "id_token=" + id_token + "&providerId=google.com",
        "requestUri": "http://localhost",
        "returnIdpCredential": true,
        "returnSecureToken": true
    }
    var headers2 = PackedStringArray(["Content-Type: application/json"])
    http.request(url, headers2, HTTPClient.METHOD_POST, JSON.stringify(payload))

func _send_auth_request(action: String, endpoint: String, payload: Dictionary):
    if http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
        print("FIREBASE REQUEST BUSY")
        return
    pending_action = action
    var url = "https://identitytoolkit.googleapis.com/v1/" + endpoint + "?key=" + FirebaseConfig.API_KEY
    var headers = PackedStringArray(["Content-Type: application/json"])
    var error = http.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
    if error != OK:
        print("FIREBASE REQUEST START ERROR: ", error)
        auth_completed.emit(false, {"message": "تعذر بدء الاتصال"})

func _on_request_completed(result, response_code, _headers, body):
    var data = JSON.parse_string(body.get_string_from_utf8())
    if not data is Dictionary:
        data = {}
    if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
        print("FIREBASE AUTH SUCCESS: ", pending_action)
        auth_completed.emit(true, data)
    else:
        var message = "فشل الاتصال بخدمة الحسابات"
        if data.has("error"):
            message = str(data["error"].get("message", message))
        print("FIREBASE AUTH FAILED: ", message)
        auth_completed.emit(false, {"message": message})
    pending_action = ""
