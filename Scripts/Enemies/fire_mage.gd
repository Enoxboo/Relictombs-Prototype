extends Enemy

# === RANGED ATTACK PROPERTIES ===
var projectile_speed: int = 200
var projectile_time: int = 500

# === PRELOADED RESOURCES ===
const PROJECTILE = preload("res://Scenes/Spells/projectile.tscn")
const FIREBALL = preload("res://Sprites/Spells/Fireball.png")

# === INITIALIZATION ===
func _ready() -> void:
	super._ready()
	
	# Configure ranged enemy specific stats
	speed = 100
	chase_distance = 300
	attack_distance = 180

# === OVERRIDDEN ATTACK BEHAVIOR ===
func attack_state() -> void:
	super.attack_state()
	
	# Only attack if not on cooldown
	if can_attack:
		shoot_projectile()
		handle_attack_cooldown()

# === RANGED COMBAT METHODS ===
func shoot_projectile() -> void:
	# Prevent multiple attacks
	can_attack = false
	
	# Create and configure projectile
	var projectile_instance = PROJECTILE.instantiate()
	projectile_instance.speed = projectile_speed if distance_x < 0 else -projectile_speed
	projectile_instance.direction = Vector2(1, 0)
	projectile_instance.global_position = global_position + Vector2(0, -8.0)
	projectile_instance.time = projectile_time
	projectile_instance.collision_layer = 2
	projectile_instance.collision_mask = 8
	projectile_instance.sprite_texture = FIREBALL
	
	# Add projectile to scene
	get_tree().current_scene.add_child(projectile_instance)

func handle_attack_cooldown() -> void:
	# Return to chase state after shooting
	await Utils.wait_frames(30)
	current_state = State.Chase
	
	# Enable attacking again after cooldown
	await Utils.wait_frames(130)
	can_attack = true
