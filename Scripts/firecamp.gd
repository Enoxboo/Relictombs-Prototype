extends Area2D

@export var heal_amount : int = 1

@onready var label: Label = $Label
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var player : CharacterBody2D

func _ready() -> void:
	label.visible = false

func _process(delta: float) -> void:
	if label.visible == true and Input.is_action_just_pressed("interract"):
		player.heal(heal_amount)
		monitoring = false
		label.visible = false

func _on_body_entered(body: Node2D) -> void:
	label.visible = true
	player = body

func _on_body_exited(body: Node2D) -> void:
	label.visible = false
