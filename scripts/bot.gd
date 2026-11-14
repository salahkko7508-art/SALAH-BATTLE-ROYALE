extends CharacterBody3D

@export var speed = 3.0
@export var hp = 50
@export var damage = 10
@export var is_alive = true

var player = null
var target_pos = Vector3.ZERO
var change_timer = 0.0

func _ready():
    # دور على اللاعب في المشهد
    player = get_tree().get_first_node_in_group("player")
    target_pos = global_position + Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))

func _physics_process(delta):
    if not is_alive:
        return
    change_timer -= delta
    if change_timer <= 0:
        # كل 3 ثواني غير اتجاه المشي
        target_pos = global_position + Vector3(randf_range(-15, 15), 0, randf_range(-15, 15))
        change_timer = 3.0
    
    # لو اللاعب قريب، اجري وراه
    if player != null and global_position.distance_to(player.global_position) < 15:
        target_pos = player.global_position
    
    var dir = (target_pos - global_position).normalized()
    dir.y = 0
    velocity.x = dir.x * speed
    velocity.z = dir.z * speed
    move_and_slide()
    
    # لو وصلت للاعب، اضربو
    if player != null and global_position.distance_to(player.global_position) < 2:
        if player.has_method("take_damage"):
            player.take_damage(damage * delta)

func take_damage(amount):
    if not is_alive:
        return
    hp -= amount
    print("البوت انضرب! دمو: ", hp)
    if hp <= 0:
        die()

func die():
    is_alive = false
    print("قتلت بوت! +20 S")
    Global.coins += 20
    Global.xp += 20
    queue_free()
