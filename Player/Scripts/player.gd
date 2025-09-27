extends CharacterBody2D
class_name Player

# === CONSTANTS ===
const BASE_HITBOX_POS: Vector2 = Vector2(0.0, -8.0)
const INVINCIBLE_ALPHA: float = 0.3
const BASE_ALPHA: float = 1.0
const TOTAL_FLASHES: int = 8
const FLASH_DURATION: float = 0.06
const INVULNERABILITY_DURATION: int = 100

# === VARIABLES ===
@export var speed: int = 225
@export var jump_force: int = -305
@export var max_health: int = 10
@export var dash_force: int = 500
var health: int
var last_direction: float = 1.0
var can_attack: bool = true
var can_dash: bool = true
var is_invulnerable: bool = false
var is_dashing: bool = false
var is_active: bool = false

# === NODE REFERENCES ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = get_node_or_null("Sword")
@onready var collision_shape: CollisionShape2D = get_node_or_null("Sword/CollisionShape2D")
@onready var hitbox_sprite: Sprite2D = get_node_or_null("Sword/CollisionShape2D/HitboxSprite")
@onready var hurtbox: Area2D = $Hurtbox
@onready var elements: Node2D = get_node_or_null("Elements")

# === INITIALIZATION ===
func _ready() -> void:
	health = max_health
	if hitbox:
		hitbox.monitoring = false
		hitbox_sprite.visible = false
	if is_active == false:
		process_mode = Node.PROCESS_MODE_DISABLED

# === MAIN PHYSICS LOOP ===
func _physics_process(delta: float) -> void:
	Utils.apply_gravity(self, delta)
	handle_movement()
	handle_jump()
	move_and_slide()

# === MOVEMENT SYSTEM ===
func handle_movement() -> void:
	if is_dashing:
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

# === COMBAT SYSTEM ===
func take_damage(damage: int) -> void:
	# Ignore damage during invulnerability frames
	if is_invulnerable:
		return
		
	# Apply damage and start invulnerability
	health -= damage
	is_invulnerable = true
	
	# Create flashing visual effect
	var tween = create_tween()
	tween.set_loops(TOTAL_FLASHES)
	tween.tween_property(sprite, "modulate:a", INVINCIBLE_ALPHA, FLASH_DURATION)
	tween.tween_property(sprite, "modulate:a", BASE_ALPHA, FLASH_DURATION)
	tween.tween_callback(func(): sprite.modulate.a = BASE_ALPHA)
	
	# Wait for invulnerability to end
	await Utils.wait_frames(INVULNERABILITY_DURATION)
	is_invulnerable = false

func heal(heal_amount: int) -> void:
	health = move_toward(health, max_health, heal_amount)


func _on_tag_signal(active_player: Player) -> void:
	if self == active_player:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
