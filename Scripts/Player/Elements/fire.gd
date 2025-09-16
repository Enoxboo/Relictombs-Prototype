extends PlayerAttack

# === CONSTANTS ===
const BURN_DAMAGE: int = 1
const BURN_DURATION: int = 2

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with fire visual effect
	super.handle_attack(player)
	player.sprite.modulate = Color("RED")

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage plus burn effect
	super.enemy_hit(enemy, side)
	enemy.apply_burn(BURN_DAMAGE, BURN_DURATION)
