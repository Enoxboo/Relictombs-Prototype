extends PlayerAttack

# === CONSTANTS ===
const BOOSTED_DASH: int = 1000

var wind_player: CharacterBody2D

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with wind visual effect
	super.handle_attack(player)
	wind_player = player
	player.sprite.modulate = Color("GREEN")

func handle_dash(player: CharacterBody2D) -> void:
	# Enhanced dash when airborne
	if not player.is_on_floor():
		var initial_dash_force: int = player.dash_force
		player.dash_force = BOOSTED_DASH  # Boosted air dash
		super.handle_dash(player)
		player.dash_force = initial_dash_force
	else:
		super.handle_dash(player)

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage with air bonus
	super.enemy_hit(enemy, side)
	if not wind_player.is_on_floor():
		print("Wind air bonus activated!")
