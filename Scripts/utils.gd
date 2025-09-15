extends Node

func apply_gravity(character: CharacterBody2D, delta: float) -> void:
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta

func wait_frames(frames: int) -> void:
	for i in range(frames):
		await get_tree().physics_frame
