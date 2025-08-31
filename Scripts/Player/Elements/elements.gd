extends Node2D

enum element {None, Fire, Water, Wind, Earth}
var active_element : element
var new_element : element
@onready var none: Node2D = $None
@onready var fire: Node2D = $Fire
@onready var water: Node2D = $Water
@onready var wind: Node2D = $Wind
@onready var earth: Node2D = $Earth

func _ready() -> void:
	active_element = 0
	new_element = active_element
	fire.process_mode = Node.PROCESS_MODE_DISABLED
	water.process_mode = Node.PROCESS_MODE_DISABLED
	wind.process_mode = Node.PROCESS_MODE_DISABLED
	earth.process_mode = Node.PROCESS_MODE_DISABLED

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("switch_right"):
		new_element += 1
		if new_element == 5:
			new_element = 1
		switch_to(new_element)

	elif Input.is_action_just_pressed("switch_left"):
		new_element -= 1
		if new_element == 0:
			new_element = 4
		switch_to(new_element)

	elif Input.is_action_just_pressed("switch_reset"):
		new_element = 0
		switch_to(new_element)
	elif Input.is_action_just_pressed("attack"):
		get_active_element().handle_attack(get_parent())
	elif Input.is_action_just_pressed("special_attack"):
		get_active_element().handle_special_attack(get_parent())

func get_active_element():
	match active_element:
		0:
			return none
		1:
			return fire
		2:
			return water
		3:
			return wind
		4:
			return earth

func switch_to(next_element):
	get_active_element().process_mode = Node.PROCESS_MODE_DISABLED
	active_element = next_element
	get_active_element().process_mode = Node.PROCESS_MODE_ALWAYS


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		get_active_element().enemy_hit(get_parent(), body)
