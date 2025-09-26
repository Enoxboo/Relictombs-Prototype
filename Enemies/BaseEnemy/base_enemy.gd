extends CharacterBody2D
class_name Enemy

# === CONSTANTS ===


# === VARIABLES ===
@export var max_health: int = 3
var health: int
var speed: int = 100
var player: CharacterBody2D
var current_state: State

# === COMBAT VARIABLES ===
var hitstunned: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_friction: float = 1200.0
var is_being_knocked_back: bool = false
var knockback_strength: int = 300
var hitstun_time: int = 25
var can_attack: bool = true
var is_burned: bool = false
var burn_time_left: int = 0
var is_slow: bool = false

# === AI BEHAVIOR VARIABLES ===
var distance_x: float = 0.0
var flee_distance: float = 50.0
var flee_speed: int = 150
var chase_distance: int = 150
var attack_distance: int = 100

# === ENUMS ===
enum State {
	Idle,
	Chase,
	Attack,
	Flee
}

# === NODE REFERENCES ===
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox_sprite: Sprite2D = $Hitbox/HitboxSprite
@onready var hp_label: Label = $HPLabel
@onready var hitbox: Area2D = $Hitbox

# === LIFECYCLE METHODS ===
func _ready() -> void:
	health = max_health
	player = %Player
	current_state = State.Idle
	hitbox.monitoring = false
	update_hp_display()

func _process(delta: float) -> void:
	match current_state:
		State.Idle:
			idle_state()
		State.Chase:
			chase_state(delta)
		State.Attack:
			attack_state()
		State.Flee:
			flee_state(delta)

func _physics_process(delta: float) -> void:
	Utils.apply_gravity(self, delta)
	
	if is_being_knocked_back:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
		velocity.x = knockback_velocity.x
	
	move_and_slide()

# === STATE MANAGEMENT ===
func idle_state() -> void:
	# Wait for player to come within chase distance
	var distance_to_player = abs(global_position.x - player.global_position.x)
	if distance_to_player < chase_distance:
		current_state = State.Chase

func chase_state(_delta: float) -> void:
	if hitstunned:
		return
	
	# Calculate distance to player
	distance_x = global_position.x - player.global_position.x
	var abs_distance = abs(distance_x)
	
	# Decide next action based on distance
	if abs_distance < attack_distance:
		velocity.x = 0
		current_state = State.Attack
	elif abs_distance > chase_distance:
		velocity.x = 0
		current_state = State.Idle
	else:
		# Move towards player
		velocity.x = speed if distance_x < 0 else -speed

func attack_state() -> void:
	# Check if player moved out of attack range
	distance_x = global_position.x - player.global_position.x
	if abs(distance_x) > attack_distance:
		current_state = State.Chase

func flee_state(_delta: float) -> void:
	# Currently just returns to idle (placeholder for future implementation)
	current_state = State.Idle

# === COMBAT SYSTEM ===
func take_damage(damage: int, side: int) -> void:
	# Apply damage and handle death
	health -= damage
	update_hp_display()
	apply_knockback(side)
	
	if health <= 0:
		queue_free()

func apply_knockback(side: int) -> void:
	# Apply knockback effect and hitstun
	knockback_velocity.x = knockback_strength * side
	is_being_knocked_back = true
	hitstunned = true
	
	# Wait for hitstun to end
	await Utils.wait_frames(hitstun_time)
	hitstunned = false
	is_being_knocked_back = false

func apply_burn(damage: int, time: int) -> void:
	if is_burned:
		burn_time_left = time
		return
	
	is_burned = true
	burn_time_left = time
	_process_burn(damage)

func _process_burn(damage: int) -> void:
	while burn_time_left > 0:
		burn_time_left -= 1
		
		await Utils.wait_frames(50)
		sprite.modulate = Color("RED")
		await Utils.wait_frames(4)
		take_damage(damage, 0)
		await Utils.wait_frames(10)
		sprite.modulate = Color("WHITE")
	
	is_burned = false

func apply_slow(modifier: int, time: int) -> void:
	if is_slow:
		return
		
	is_slow = true
	sprite.modulate = Color(0.0, 0.0, 1.0, 1.0)
	for n in time:
		var initial_speed = speed
		speed *= modifier / 100.0
		await Utils.wait_frames(64)
		speed = initial_speed
	is_slow = false
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

# === UI UPDATES ===
func update_hp_display() -> void:
	hp_label.text = str(health) + "/" + str(max_health)
