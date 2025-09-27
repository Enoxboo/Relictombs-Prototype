extends Node2D

signal tag_signal(active_player: Player)
	
var players: Array[Player]

func _ready() -> void:
	get_all_players()
	players[0].is_active = true

func get_all_players() -> void:
	var all_players = get_tree().get_nodes_in_group("player")
	for player in all_players:
		if player is Player:
			players.append(player)
			tag_signal.connect(player._on_tag_signal)
	print(players)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("tag"):
		tag()

func tag():
	if players.size() <= 1:
		return
	
	players[0].is_active = !players[0].is_active
	players[1].is_active = !players[1].is_active
	var active_player = players[0] if players[0].is_active else players[1]
	emit_signal("tag_signal", active_player)
