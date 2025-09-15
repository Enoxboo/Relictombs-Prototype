extends Node2D

signal element_changed(new_element)
# Enums
enum element { None, Fire, Water, Wind, Earth }

# Variables
var active_element: element
var new_element: element

# Node references
@onready var none: Node2D = $None
@onready var fire: Node2D = $Fire
@onready var water: Node2D = $Water
@onready var wind: Node2D = $Wind
@onready var earth: Node2D = $Earth

# Lifecycle methods
func _ready() -> void:
	active_element = element.None
	new_element = active_element
	_disable_all_elements()

func _input(_event: InputEvent) -> void:
	_handle_element_switching()
	_handle_attacks()

# Input handling
func _handle_element_switching() -> void:
	if Input.is_action_just_pressed("switch_right"):
		new_element += 1
		if new_element == element.size():
			new_element = element.Fire
		switch_to(new_element)
	
	elif Input.is_action_just_pressed("switch_left"):
		new_element -= 1
		if new_element < element.Fire:
			new_element = element.Earth
		switch_to(new_element)
	
	elif Input.is_action_just_pressed("switch_reset"):
		new_element = element.None
		switch_to(new_element)

func _handle_attacks() -> void:
	if Input.is_action_just_pressed("attack"):
		get_active_element().handle_attack(get_parent())
	elif Input.is_action_just_pressed("special_attack"):
		get_active_element().handle_special_attack(get_parent())

# Element management
func get_active_element() -> Node2D:
	match active_element:
		element.None:
			return none
		element.Fire:
			return fire
		element.Water:
			return water
		element.Wind:
			return wind
		element.Earth:
			return earth
		_:
			return none

func switch_to(next_element: element) -> void:
	get_active_element().process_mode = Node.PROCESS_MODE_DISABLED
	active_element = next_element
	emit_signal("element_changed", active_element)
	get_active_element().process_mode = Node.PROCESS_MODE_ALWAYS

func _disable_all_elements() -> void:
	fire.process_mode = Node.PROCESS_MODE_DISABLED
	water.process_mode = Node.PROCESS_MODE_DISABLED
	wind.process_mode = Node.PROCESS_MODE_DISABLED
	earth.process_mode = Node.PROCESS_MODE_DISABLED

# Signal handlers
func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemy"):
		return
	
	var side = -1 if get_parent().global_position > body.global_position else 1
	get_active_element().enemy_hit(body, side)
