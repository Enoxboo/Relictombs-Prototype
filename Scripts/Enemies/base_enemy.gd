extends CharacterBody2D
class_name Enemy

# Exported variables
@export var max_health: int = 3

# Variables
var health: int
var speed: int = 100
var hitstunned: bool = false
var current_state: state
var player: CharacterBody2D
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_friction: float = 1200.0
var is_being_knocked_back: bool = false
var knockback_strenght: int = 300
var hitstun_time: int = 25
var distance_x : float = 0.0
var can_attack: bool = true
var flee_distance: float = 50.0
var flee_speed: int = 150
var chase_distance = 150
var attack_distance = 100

# Enums
enum state { Idle, Chase, Attack, Flee }

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox_sprite: Sprite2D = $Hitbox/HitboxSprite
@onready var hp_label: Label = $HPLabel
@onready var hitbox: Area2D = $Hitbox

# Lifecycle methods
func _ready() -> void:
	health = max_health
	player = %Player
	current_state = state.Idle
	hitbox.monitoring = false
	update_hp()

func _process(delta: float) -> void:
	match current_state:
		state.Idle:
			idle_state()
		state.Chase:
			chase_state(delta)
		state.Attack:
			attack_state()
		state.Flee:
			flee_state(delta)

func _physics_process(delta: float) -> void:
	Utils.apply_gravity(self, delta)
	
	if is_being_knocked_back:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
		velocity.x = knockback_velocity.x
	
	move_and_slide()

# State management
func idle_state() -> void:
	var distance = abs(global_position.x - player.global_position.x)
	if distance < chase_distance:
		current_state = state.Chase

func chase_state(delta: float) -> void:
	if hitstunned:
		return
		
	distance_x = global_position.x - player.global_position.x
	var abs_distance = abs(distance_x)
	
	if abs_distance < attack_distance:
		velocity.x = 0
		current_state = state.Attack
	elif abs_distance > chase_distance:
		velocity.x = 0
		current_state = state.Idle
	else:
		velocity.x = speed if distance_x < 0 else -speed

func attack_state() -> void:
	distance_x = global_position.x - player.global_position.x
	if abs(distance_x) > attack_distance:
		current_state = state.Chase

func flee_state(delta: float) -> void:
	current_state = state.Idle

# Combat system
func take_damage(damage: int, side: int) -> void:
	health -= damage
	update_hp()
	apply_knockback(side)
	
	if health <= 0:
		queue_free()

func apply_knockback(side: int) -> void:
	knockback_velocity.x = knockback_strenght * side
	is_being_knocked_back = true
	hitstunned = true
	
	await Utils.wait_frames(hitstun_time)
	hitstunned = false
	is_being_knocked_back = false

func apply_burn(damage: int, time: int):
	for n in time:
		await  Utils.wait_frames(50)
		sprite.modulate = Color("RED")
		await Utils.wait_frames(4)
		take_damage(1, 0)
		await Utils.wait_frames(10)
		sprite.modulate = Color("WHITE")

func apply_slow(modifier: int, time: int):
	for n in time:
		var initial_speed = speed
		speed *= modifier / 100.0
		await Utils.wait_frames(64)
		speed = initial_speed

# UI
func update_hp() -> void:
	hp_label.text = str(health) + "/" + str(max_health)
