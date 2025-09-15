extends PlayerAttack

var earth_player: CharacterBody2D

func handle_attack(player):
	super.handle_attack(player)
	earth_player = player
	player.sprite.modulate = Color("BROWN")

func handle_dash(player):
	if player.is_on_floor():
		var initial_dash_force: int = player.dash_force
		player.dash_force = 1000
		super.handle_dash(player)
		player.dash_force = initial_dash_force
	else:
		super.handle_dash(player)

func enemy_hit(enemy: Node2D, side: int) -> void:
	super.enemy_hit(enemy, side)
	if earth_player.is_on_floor():
		print("boosted")
