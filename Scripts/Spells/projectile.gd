extends Area2D

# === NODE REFERENCES ===
@onready var sprite: Sprite2D = $Sprite2D

# === PROJECTILE PROPERTIES ===
var sprite_texture: Texture2D
var direction: Vector2
var speed: int
var time: int

# === INITIALIZATION ===
func _ready() -> void:
	if sprite_texture:
		sprite.texture = sprite_texture

# === PROJECTILE MOVEMENT ===
func _process(delta: float) -> void:
	# Move projectile in specified direction
	position += direction * speed * delta
	
	# Auto-destroy after specified time
	await Utils.wait_frames(time)
	queue_free()

# === COLLISION DETECTION ===
func _on_area_entered(area: Area2D) -> void:
	# Check if we hit a valid target
	if not (area.collision_layer & 8):
		return
	
	# Deal damage to the target and destroy projectile
	area.get_parent().take_damage(1)
	queue_free()
