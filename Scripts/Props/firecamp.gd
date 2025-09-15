extends Area2D

# === VARIABLES ===
var player: CharacterBody2D
@export var heal_amount: int = 1

# === NODE REFERENCES ===
@onready var label: Label = $Label
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# === INITIALIZATION ===
func _ready() -> void:
	# Hide interaction label initially
	label.visible = false

# === MAIN LOOP ===
func _process(_delta: float) -> void:
	# Check for interaction input when label is visible
	if label.visible and Input.is_action_just_pressed("interract"):
		use_heal_pickup()

# === HEALING SYSTEM ===
func use_heal_pickup() -> void:
	# Heal the player and disable the firecamp
	player.heal(heal_amount)
	monitoring = false
	label.visible = false

# === INTERACTION DETECTION ===
func _on_body_entered(body: Node2D) -> void:
	# Show interaction prompt when player enters
	label.visible = true
	player = body

func _on_body_exited(_body: Node2D) -> void:
	# Hide interaction prompt when player leaves
	label.visible = false
