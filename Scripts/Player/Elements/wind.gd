extends PlayerAttack

var wind_player: CharacterBody2D

func handle_attack(player):
	super.handle_attack(player)
	wind_player = player
	player.sprite.modulate = Color("GREEN")

func enemy_hit(enemy: Node2D, side: int) -> void:
	super.enemy_hit(enemy, side)
	if not wind_player.is_on_floor():
		print("boosted")
