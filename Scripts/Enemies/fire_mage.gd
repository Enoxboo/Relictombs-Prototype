extends Enemy

var projectile_speed = 200
var projectile_time = 500
const PROJECTILE = preload("res://Scenes/projectile.tscn")
const FIREBALL = preload("res://Sprites/Fireball.png")

func _ready() -> void:
	super._ready()
	speed = 100 
	chase_distance = 300
	attack_distance = 180

func attack_state() -> void:
	super.attack_state()
	if can_attack:
		can_attack = false
		
		var projectile_instance = PROJECTILE.instantiate()
		projectile_instance.speed = projectile_speed if distance_x < 0 else -projectile_speed
		projectile_instance.direction = Vector2(1, 0)
		
		projectile_instance.global_position = global_position + Vector2(0, -8.0)
		
		projectile_instance.time = projectile_time
		projectile_instance.collision_layer = 2
		projectile_instance.collision_mask = 8
		projectile_instance.sprite_texture = FIREBALL
		
		get_tree().current_scene.add_child(projectile_instance)
		
		await Utils.wait_frames(30)
		
		current_state = state.Chase
		
		await Utils.wait_frames(130) 
		can_attack = true
