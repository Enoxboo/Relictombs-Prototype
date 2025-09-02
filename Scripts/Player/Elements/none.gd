extends Node2D

const BASE_ATTACK_POS_R : Vector2 = Vector2(20, -8)
const BASE_ATTACK_POS_L : Vector2 = Vector2(-20, -8)
const BASE_ATTACK_POS_U : Vector2 = Vector2(0, -20)
const BASE_ATTACK_POS_D : Vector2 = Vector2(0, 20)
const SWORD_SLASH = preload("res://Sprites/Player/Weapons/sword_slash.png")
const SPE_ATTACK_POS : Vector2 = Vector2(10.0, -8.0)
const SPE_ATTACK_POS_L : Vector2 = Vector2(-10.0, -8.0)

var vertical_attack : bool = false
var can_attack : bool = true
var frame_counter := 0

func handle_attack(player):
	var dir = get_attack_direction(player)
	if dir.x > 0: # Droite
		attack(player, BASE_ATTACK_POS_R, 4, 8, 20, 0)
	elif dir.x < 0: # Gauche
		attack(player, BASE_ATTACK_POS_L, 4, 8, 20, 180)
	elif dir.y < 0: # Haut
		attack(player, BASE_ATTACK_POS_U, 4, 8, 20, -90)
	elif dir.y > 0: # Bas
		attack(player, BASE_ATTACK_POS_D, 4, 8, 20, 90)

func handle_special_attack(player):
	pass

func attack(player, pos: Vector2, startup: int, active: int, recovery: int, angle: float) -> void:
	if can_attack:
		can_attack = false
		
		await wait_frames(startup)
		
		show_visual(player, SWORD_SLASH)
		player.collision_shape.position = pos
		player.hitbox_sprite.rotation = deg_to_rad(angle)
		player.hitbox.monitoring = true
		
		await wait_frames(active)
		
		remove_visual(player)
		player.collision_shape.position = player.BASE_HITBOX_POS
		player.hitbox.monitoring = false
		
		can_attack = true


func wait_frames(frames: int) -> void:
	for i in range(frames):
		await get_tree().process_frame

func show_visual(player, sprite):
	player.hitbox_sprite.texture = sprite
	player.hitbox_sprite.visible = true

func remove_visual(player):
	player.hitbox_sprite.texture = null
	player.hitbox_sprite.visible = false
	player.hitbox_sprite.rotation = 0.0

func get_attack_direction(player) -> Vector2:
	var dir = Vector2.ZERO

	if Input.is_action_pressed("look_up"):
		dir.y = -1
	elif Input.is_action_pressed("crouch"):
		dir.y = 1
	else:
		dir.x = player.last_direction

	return dir

func enemy_hit(player, enemy, side):
	enemy.take_damage(1, side)
