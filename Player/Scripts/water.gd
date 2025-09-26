extends PlayerAttack

# === CONSTANTS ===
const SLOW_STRENGHT: int = 50
const SLOW_DURATION: int = 2
const WATER_PARTICULE = preload("uid://m52e1wlvdxcx")

var fire_textures = [
	preload("uid://btagybtsyr18e"),
	preload("uid://b5ugmtiqllr47"),
	preload("uid://dh7j65u8xg6q0"),
	preload("uid://bkimr0538ms7q")
]

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with water visual effect
	super.handle_attack(player)
	player.sprite.modulate = Color("BLUE")

func handle_dash(player: CharacterBody2D) -> void:
	super.handle_dash(player)
	for n in 5:
		for m in 20:
			var rand_x = randf_range(-10, 10)
			var rand_y = randf_range(-50, 10)
			var rand_sprite = randi_range(0, 3)
			var obj = WATER_PARTICULE.instantiate()
			obj.global_position = global_position + OFFSET + Vector2(rand_x, rand_y)
			obj.set_texture(fire_textures[rand_sprite])
			obj.speed = randi_range(5, 15)
			obj.time = randf_range(0.7, 1.5)
			get_tree().current_scene.add_child(obj)
		await Utils.wait_frames(3)

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage plus slow effect
	super.enemy_hit(enemy, side)
	enemy.apply_slow(50, 2)  # 50% speed for 2 seconds
