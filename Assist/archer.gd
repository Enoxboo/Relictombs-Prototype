extends Player

const PROJECTILE_SPEED: int = 600
const PROJECTILE_TIME: int = 500
const OFFSET: Vector2 = Vector2(0, -8.0)
const PROJECTILE_LAYER: int = 2
const PROJECTILE_MASK: int = 4

const PROJECTILE = preload("uid://denyaa822eoig")
const SWORD_SLASH = preload("uid://lkilncex4xsm")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		var arrow = PROJECTILE.instantiate()
		arrow.speed = PROJECTILE_SPEED if last_direction > 0 else -PROJECTILE_SPEED
		arrow.direction = Vector2(1, 0)
		arrow.global_position = global_position + OFFSET
		arrow.time = PROJECTILE_TIME
		arrow.collision_layer = PROJECTILE_LAYER
		arrow.collision_mask = PROJECTILE_MASK
		arrow.sprite_texture = SWORD_SLASH
	
	# Add projectile to scene
		get_tree().current_scene.add_child(arrow)
		
	
