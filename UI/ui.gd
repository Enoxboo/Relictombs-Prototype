extends CanvasLayer

# === NODE REFERENCES ===
@onready var hp_bar: TextureProgressBar = $HpBar
@onready var player: CharacterBody2D = %Player
@onready var texture_rect: TextureRect = $TextureRect

# === ELEMENT WHEEL TEXTURES ===
var element_textures = {
	0: preload("res://UI/ElementWheel/element_wheel0.png"),
	1: preload("res://UI/ElementWheel/element_wheel1.png"),
	2: preload("res://UI/ElementWheel/element_wheel2.png"),
	3: preload("res://UI/ElementWheel/element_wheel3.png"),
	4: preload("res://UI/ElementWheel/element_wheel4.png")
}

# === INITIALIZATION ===
func _ready() -> void:
	player.elements.connect("element_changed", _on_element_changed)

# === UI UPDATES ===
func _process(_delta: float) -> void:
	hp_bar.value = player.health

# === SIGNAL HANDLERS ===
func _on_element_changed(new_element: int) -> void:
	texture_rect.texture = element_textures[new_element]
