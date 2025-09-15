extends Node

# === PHYSICS UTILITIES ===

## Applies gravity to a CharacterBody2D if it's not on the floor
func apply_gravity(character: CharacterBody2D, delta: float) -> void:
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta

# === TIMING UTILITIES ===

## Waits for a specified number of physics frames
func wait_frames(frames: int) -> void:
	for i in range(frames):
		await get_tree().physics_frame
