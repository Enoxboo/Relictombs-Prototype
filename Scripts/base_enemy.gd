extends CharacterBody2D

@onready var hp_label: Label = $HPLabel

@export var max_health : int = 3
var health := max_health

func _ready() -> void:
	update_hp()

func take_damage(damage):
	health -= damage
	update_hp()
	if health <= 0:
		queue_free()

func update_hp():
	hp_label.text = (str(health) + "/" + str(max_health))
