extends CharacterBody2D

# Constants
const BASE_HITBOX_POS: Vector2 = Vector2(0.0, -8.0)

# Variables
@export var speed: int = 225
@export var jump_force: int = -305
@export var max_health: int = 10
var health: int
var last_direction: float = 1.0
var can_attack: bool = true
var is_invulnerable: bool = false

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox_sprite: Sprite2D = $Hitbox/CollisionShape2D/HitboxSprite
@onready var hurtbox: Area2D = $Hurtbox
@onready var elements: Node2D = $Elements

# Lifecycle methods
func _ready() -> void:
	health = max_health
	hitbox.monitoring = false
	hitbox_sprite.visible = false

func _physics_process(delta: float) -> void:
	Utils.apply_gravity(self, delta)
	move()
	jump()
	move_and_slide()

# Movement
func move() -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * speed
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

# Combat
func take_damage(damage: int) -> void:
	if is_invulnerable:
		return
		
	health -= damage
	is_invulnerable = true
	# Effet visuel
	var tween = create_tween()
	tween.set_loops(int(2 * 4))
	tween.tween_property(sprite, "modulate:a", 0.3, 0.06)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.06)
	tween.tween_callback(func(): sprite.modulate.a = 1.0)
	
	await Utils.wait_frames(100)
	is_invulnerable = false

func heal(heal_amount: int) -> void:
	health = move_toward(health, max_health, heal_amount)
