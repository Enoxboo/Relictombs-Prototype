extends Node2D
class_name PlayerAttack

# Constants
const BASE_ATTACK_POS_R: Vector2 = Vector2(20, -8)
const BASE_ATTACK_POS_L: Vector2 = Vector2(-20, -8)
const BASE_ATTACK_POS_U: Vector2 = Vector2(0, -20)
const BASE_ATTACK_POS_D: Vector2 = Vector2(0, 20)
const SWORD_SLASH = preload("res://Sprites/Player/Weapons/sword_slash.png")
const SPE_ATTACK_POS: Vector2 = Vector2(10.0, -8.0)
const SPE_ATTACK_POS_L: Vector2 = Vector2(-10.0, -8.0)

# Attack handling
func handle_attack(player: CharacterBody2D) -> void:
	var dir = get_attack_direction(player)
	
	if dir.x > 0:  # Droite
		attack(player, BASE_ATTACK_POS_R, 4, 8, 20, 0)
	elif dir.x < 0:  # Gauche
		attack(player, BASE_ATTACK_POS_L, 4, 8, 20, 180)
	elif dir.y < 0:  # Haut
		attack(player, BASE_ATTACK_POS_U, 4, 8, 20, -90)
	elif dir.y > 0:  # Bas
		attack(player, BASE_ATTACK_POS_D, 4, 8, 20, 90)

func handle_special_attack(player: CharacterBody2D) -> void:
	pass

# Attack system
func attack(player: CharacterBody2D, pos: Vector2, startup: int, active: int, recovery: int, angle: float) -> void:
	if not player.can_attack:
		return
	
	player.can_attack = false
	
	await Utils.wait_frames(startup)
	
	show_visual(player, SWORD_SLASH)
	player.collision_shape.position = pos
	player.hitbox_sprite.rotation = deg_to_rad(angle)
	player.hitbox.monitoring = true
	
	await Utils.wait_frames(active)
	
	remove_visual(player)
	player.collision_shape.position = player.BASE_HITBOX_POS
	player.hitbox.monitoring = false
	
	await Utils.wait_frames(recovery)
	
	player.can_attack = true

# Direction handling
func get_attack_direction(player: CharacterBody2D) -> Vector2:
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("look_up"):
		dir.y = -1
	elif Input.is_action_pressed("crouch"):
		dir.y = 1
	else:
		dir.x = player.last_direction
	
	return dir

# Combat
func enemy_hit(enemy: Node2D, side: int) -> void:
	enemy.take_damage(1, side)

# Visual effects
func show_visual(player: CharacterBody2D, sprite: Texture2D) -> void:
	player.hitbox_sprite.texture = sprite
	player.hitbox_sprite.visible = true

func remove_visual(player: CharacterBody2D) -> void:
	player.hitbox_sprite.texture = null
	player.hitbox_sprite.visible = false
	player.hitbox_sprite.rotation = 0.0
