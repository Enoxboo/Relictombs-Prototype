extends PlayerAttack

func handle_attack(player):
	super.handle_attack(player)
	player.sprite.modulate = Color("BLUE")

func enemy_hit(enemy: Node2D, side: int) -> void:
	super.enemy_hit(enemy, side)
	enemy.apply_slow(50, 2)
