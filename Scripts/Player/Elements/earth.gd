extends PlayerAttack

var earth_player: CharacterBody2D

func handle_attack(player):
	super.handle_attack(player)
	earth_player = player
	player.sprite.modulate = Color("BROWN")

func enemy_hit(enemy: Node2D, side: int) -> void:
	super.enemy_hit(enemy, side)
	if earth_player.is_on_floor():
		print("boosted")
