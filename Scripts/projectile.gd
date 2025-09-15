extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

var sprite_texture: Texture2D
var direction: Vector2
var speed: int
var time: int

func _ready():
	if sprite_texture:
		sprite.texture = sprite_texture

func _process(delta):
	position += direction * speed * delta
	await Utils.wait_frames(time)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if not (area.collision_layer & 8):
		return
	area.get_parent().take_damage(1)
	queue_free()
