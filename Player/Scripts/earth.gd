extends PlayerAttack

# === CONSTANTS ===
const BOOSTED_DASH: int = 1000

var earth_player: CharacterBody2D

func handle_attack(player: CharacterBody2D) -> void:
	# Execute base attack with earth visual effect
	super.handle_attack(player)
	earth_player = player
	player.sprite.modulate = Color("BROWN")

func handle_dash(player: CharacterBody2D) -> void:
	# Enhanced dash when on ground
	if player.is_on_floor():
		var initial_dash_force: int = player.dash_force
		player.dash_force = BOOSTED_DASH  # Boosted ground dash
		super.handle_dash(player)
		player.dash_force = initial_dash_force
	else:
		super.handle_dash(player)

func enemy_hit(enemy: Node2D, side: int) -> void:
	# Base damage with ground bonus
	super.enemy_hit(enemy, side)
	if earth_player.is_on_floor():
		print("Earth ground bonus activated!")
