extends Node2D

@onready var hp_bar: TextureProgressBar = $CanvasLayer/HpBar
@onready var player: CharacterBody2D = $Player


func _process(_delta: float) -> void:
	hp_bar.value = player.health
