extends Node2D
class_name PlayerAttack

# === CONSTANTS ===
const BASE_ATTACK_POS_R: Vector2 = Vector2(20, -8)    # Right attack
const BASE_ATTACK_POS_L: Vector2 = Vector2(-20, -8)   # Left attack
const BASE_ATTACK_POS_U: Vector2 = Vector2(0, -20)    # Up attack
const BASE_ATTACK_POS_D: Vector2 = Vector2(0, 20)     # Down attack
const SPE_ATTACK_POS: Vector2 = Vector2(10.0, -8.0)   # Special attack right
const SPE_ATTACK_POS_L: Vector2 = Vector2(-10.0, -8.0) # Special attack left
const STARTUP: int = 4
const ACTIVE: int = 8
const RECOVERY: int = 20
const ANGLE_RIGHT: int = 0
const ANGLE_LEFT: int = 180
const ANGLE_UP: int = -90
const ANGLE_DOWN: int = 90

# === VISUAL RESOURCES ===
const SWORD_SLASH = preload("res://Player/_Sprites/sword_slash.png")

# === ATTACK HANDLING ===
func handle_attack(player: CharacterBody2D) -> void:
	# Determine attack direction and execute attack
	var direction = get_attack_direction(player)
	
	if direction.x > 0:      # Right
		attack(player, BASE_ATTACK_POS_R, STARTUP, ACTIVE, RECOVERY, ANGLE_RIGHT)
	elif direction.x < 0:    # Left
		attack(player, BASE_ATTACK_POS_L, STARTUP, ACTIVE, RECOVERY, ANGLE_LEFT)
	elif direction.y < 0:    # Up
		attack(player, BASE_ATTACK_POS_U, STARTUP, ACTIVE, RECOVERY, ANGLE_UP)
	elif direction.y > 0:    # Down
		attack(player, BASE_ATTACK_POS_D, STARTUP, ACTIVE, RECOVERY, ANGLE_DOWN)

func handle_special_attack(_player: CharacterBody2D) -> void:
	# Not implemented yet
	pass

func handle_dash(player: CharacterBody2D) -> void:
	# Don't dash if on cooldown
	if not player.can_dash:
		return
	
	# Start dash
	player.can_dash = false
	player.is_dashing = true 
	player.velocity.x = player.dash_force * player.last_direction
	
	# Short dash duration
	await Utils.wait_frames(10)
	player.is_dashing = false
	player.velocity.x *= 0.3  # Reduce momentum
	
	# Dash cooldown
	await Utils.wait_frames(54)
	player.can_dash = true

# === ATTACK SYSTEM ===
func attack(player: CharacterBody2D, pos: Vector2, startup: int, active: int, recovery: int, angle: float) -> void:
	if not player.can_attack:
		return
	
	player.can_attack = false
	
	# Startup frames (preparation)
	await Utils.wait_frames(startup)
	
	# Active frames (hitbox is active)
	show_attack_visual(player, SWORD_SLASH)
	player.collision_shape.position = pos
	player.hitbox_sprite.rotation = deg_to_rad(angle)
	player.hitbox.monitoring = true
	
	await Utils.wait_frames(active)
	
	# Recovery frames
	remove_attack_visual(player)
	player.collision_shape.position = player.BASE_HITBOX_POS
	player.hitbox.monitoring = false
	
	await Utils.wait_frames(recovery)
	player.can_attack = true

# === DIRECTION HANDLING ===
func get_attack_direction(player: CharacterBody2D) -> Vector2:
	# Determine attack direction based on input
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("look_up"):
		direction.y = -1
	elif Input.is_action_pressed("crouch"):
		direction.y = 1
	else:
		direction.x = player.last_direction
	
	return direction

# === COMBAT EFFECTS ===
func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage - override in element classes for additional effects
	enemy.take_damage(1, side)

# === VISUAL EFFECTS ===
func show_attack_visual(player: CharacterBody2D, sprite: Texture2D) -> void:
	# Show attack visual effect
	player.hitbox_sprite.texture = sprite
	player.hitbox_sprite.visible = true

func remove_attack_visual(player: CharacterBody2D) -> void:
	# Clean up attack visual
	player.hitbox_sprite.texture = null
	player.hitbox_sprite.visible = false
	player.hitbox_sprite.rotation = 0.0
