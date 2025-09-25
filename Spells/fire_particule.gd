extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
var pending_texture: Texture2D
var speed: int
var time: float = 0.7

func _ready() -> void:
	if pending_texture and sprite:
		sprite.texture = pending_texture

func _process(delta: float) -> void:
	position.y -= speed * delta
	sprite.modulate.a = move_toward(sprite.modulate.a, 0, time * delta)

func set_texture(texture: Texture2D) -> void:
	if sprite:
		sprite.texture = texture
	else:
		pending_texture = texture

func _on_area_body_entered(body: Node2D) -> void:
	if body.has_method("apply_burn"):
		body.apply_burn(1, 1)

func _on_timer_timeout() -> void:
	queue_free()
