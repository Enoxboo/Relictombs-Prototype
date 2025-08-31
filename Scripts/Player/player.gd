extends CharacterBody2D

@export var speed : int = 300
@export var jump_force : int = -300
@export var health : int = 10

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox_sprite: Sprite2D = $Hitbox/CollisionShape2D/HitboxSprite

const BASE_HITBOX_POS : Vector2 = Vector2(0.0, -8.0)
var last_direction := 1.0

func _ready() -> void:
	hitbox.monitoring = false
	hitbox_sprite.visible = false

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move()
	jump()
	move_and_slide()

func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func move() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func take_damage(damage) -> void:
	health -= damage
