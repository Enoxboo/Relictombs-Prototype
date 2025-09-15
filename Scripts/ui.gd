extends CanvasLayer

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var player: CharacterBody2D = %Player
@onready var texture_rect: TextureRect = $TextureRect

var element_textures = {
	0: preload("res://Sprites/UI/ElementWheel/ElementWheel0.png"),
	1: preload("res://Sprites/UI/ElementWheel/ElementWheel1.png"),
	2: preload("res://Sprites/UI/ElementWheel/ElementWheel2.png"),
	3: preload("res://Sprites/UI/ElementWheel/ElementWheel3.png"),
	4: preload("res://Sprites/UI/ElementWheel/ElementWheel4.png")
}

func _ready() -> void:
	player.elements.connect("element_changed", _element_changed)

func _process(delta: float) -> void:
	hp_bar.value = player.health

func _element_changed(new_element) -> void:
	print(new_element)
	texture_rect.texture = element_textures[new_element]
