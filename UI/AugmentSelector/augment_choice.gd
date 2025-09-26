extends Control

@onready var button: Button = $Button
var player: Player
var rolled_augment: Augment

func _ready() -> void:
	rolled_augment = AugmentData.get_random_augment()
	button.text = rolled_augment.augment_name
	player = get_tree().get_first_node_in_group("player")

func _on_button_button_down() -> void:
	player.elements.add_augment(rolled_augment.element, rolled_augment)
	print(player.elements.player_augments)
