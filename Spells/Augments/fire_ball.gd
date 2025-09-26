extends Node2D

var speed: int = 100
var player: Player
var side: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	side = player.last_direction

func _process(delta: float) -> void:
	position.x += speed * side * delta
