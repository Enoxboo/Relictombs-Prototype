extends Node2D

@export var loaded_scene: PackedScene


func _on_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_packed(loaded_scene)
