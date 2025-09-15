extends PlayerAttack

func handle_attack(player):
	super.handle_attack(player)
	player.sprite.modulate = Color("RED")

func enemy_hit(enemy: Node2D, side: int) -> void:
	super.enemy_hit(enemy, side)
	enemy.apply_burn(1, 2)
