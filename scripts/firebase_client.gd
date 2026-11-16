extends Node

signal auth_completed(success: bool, data: Dictionary)

const FirebaseConfig = preload("res://scripts/firebase_config.gd")

var http: HTTPRequest
var pending_action = ""

func _ready():
    http = HTTPRequest.new()
    http.timeout = 20.0
    add_child(http)
    http.request_completed.connect(_on_request_completed)
    print("FIREBASE CLIENT READY")

func create_account(email: String, password: String):
    var payload = {
        "email": email.strip_edges(),
        "password": password,
        "returnSecureToken": true
    }
    _send_auth_request("signup", "accounts:signUp", payload)

func sign_in(email: String, password: String):
    var payload = {
        "email": email.strip_edges(),
        "password": password,
        "returnSecureToken": true
    }
    _send_auth_request("login", "accounts:signInWithPassword", payload)

func _send_auth_request(action: String, endpoint: String, payload: Dictionary):
    if http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
        print("FIREBASE REQUEST BUSY")
        return

    pending_action = action

    var url = "https://identitytoolkit.googleapis.com/v1/" + endpoint + "?key=" + FirebaseConfig.API_KEY
    var headers = PackedStringArray(["Content-Type: application/json"])
    var error = http.request(
        url,
        headers,
        HTTPClient.METHOD_POST,
        JSON.stringify(payload)
    )

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
