extends PlayerAttack

# === CONSTANTS ===
const BURN_DAMAGE: int = 1
const BURN_DURATION: int = 2
const OFFSET: Vector2 = Vector2(0, -8)
const FIRE_PARTICULE = preload("uid://64ajwqvhfve6")

# tests
const FIRE_BALL = preload("uid://cfigi5yskyn7a")

var fire_textures = [
	preload("uid://btagybtsyr18e"),
	preload("uid://b5ugmtiqllr47"),
	preload("uid://dh7j65u8xg6q0"),
	preload("uid://bkimr0538ms7q")
]

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with fire visual effect
	super.handle_attack(player)
	player.sprite.modulate = Color("RED")

func handle_dash(player: CharacterBody2D) -> void:
	super.handle_dash(player)
	for n in 5:
		for m in 10:
			var rand_x = randf_range(-10, 10)
			var rand_y = randf_range(-10, 10)
			var rand_sprite = randi_range(0, 3)
			var obj = FIRE_PARTICULE.instantiate()
			obj.global_position = global_position + OFFSET + Vector2(rand_x, rand_y)
			obj.set_texture(fire_textures[rand_sprite])
			obj.speed = randi_range(5, 15)
			obj.time = randf_range(0.7, 1.5)
			get_tree().current_scene.add_child(obj)
		await Utils.wait_frames(3)

func handle_special_attack(_player: CharacterBody2D) -> void:
	var fire_ball = FIRE_BALL.instantiate()
	fire_ball.global_position = global_position + OFFSET
	get_tree().current_scene.add_child(fire_ball)

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage plus burn effect
	super.enemy_hit(enemy, side)
	enemy.apply_burn(BURN_DAMAGE, BURN_DURATION)
