extends PlayerAttack

# === CONSTANTS ===
const SLOW_STRENGHT: int = 50
const SLOW_DURATION: int = 2

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with water visual effect
	super.handle_attack(player)
	player.sprite.modulate = Color("BLUE")

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage plus slow effect
	super.enemy_hit(enemy, side)
	enemy.apply_slow(50, 2)  # 50% speed for 2 seconds
