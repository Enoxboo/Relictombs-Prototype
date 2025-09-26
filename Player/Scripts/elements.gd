extends Node2D

# === SIGNALS ===
signal element_changed(new_element)

# === ENUMS ===
enum Element { None, Fire, Water, Wind, Earth }

# === VARIABLES ===
var active_element: Element
var new_element: Element
var player_augments: Dictionary = {
	Element.None: null,
	Element.Fire: null,
	Element.Water: null,
	Element.Wind: null,
	Element.Earth: null
}

# === NODE REFERENCES ===
@onready var none: Node2D = $None
@onready var fire: Node2D = $Fire
@onready var water: Node2D = $Water
@onready var wind: Node2D = $Wind
@onready var earth: Node2D = $Earth

# === INITIALIZATION ===
func _ready() -> void:
	active_element = Element.None
	new_element = active_element
	disable_all_elements()

# === INPUT HANDLING ===
func _input(_event: InputEvent) -> void:
	handle_element_switching()
	handle_attacks()
	handle_dash()

# === ELEMENT SWITCHING ===
func handle_element_switching() -> void:
	# Cycle to next element
	if Input.is_action_just_pressed("switch_right"):
		new_element += 1
		if new_element == Element.size():
			new_element = Element.Fire
		switch_to(new_element)
	
	# Cycle to previous element
	elif Input.is_action_just_pressed("switch_left"):
		new_element -= 1
		if new_element < Element.Fire:
			new_element = Element.Earth
		switch_to(new_element)
	
	# Reset to no element
	elif Input.is_action_just_pressed("switch_reset"):
		new_element = Element.None
		switch_to(new_element)

# === HANDLERS ===
func handle_attacks() -> void:
	var current_element = get_active_element()
	
	if Input.is_action_just_pressed("attack"):
		current_element.handle_attack(get_parent())
	elif Input.is_action_just_pressed("special_attack") and player_augments[active_element]:
		current_element.handle_special_attack(get_parent(), player_augments[active_element])

func handle_dash() -> void:
	var current_element = get_active_element()
	if Input.is_action_just_pressed("dash"):
		current_element.handle_dash(get_parent())

# === ELEMENT MANAGEMENT ===
func get_active_element() -> Node2D:
	# Return the currently active element node
	match active_element:
		Element.None:
			return none
		Element.Fire:
			return fire
		Element.Water:
			return water
		Element.Wind:
			return wind
		Element.Earth:
			return earth
		_:
			return none

func switch_to(next_element: Element) -> void:
	# Disable current element and switch to new one
	get_active_element().process_mode = Node.PROCESS_MODE_DISABLED
	active_element = next_element
	emit_signal("element_changed", active_element)
	get_active_element().process_mode = Node.PROCESS_MODE_ALWAYS

func disable_all_elements() -> void:
	# Disable all elemental abilities
	fire.process_mode = Node.PROCESS_MODE_DISABLED
	water.process_mode = Node.PROCESS_MODE_DISABLED
	wind.process_mode = Node.PROCESS_MODE_DISABLED
	earth.process_mode = Node.PROCESS_MODE_DISABLED

func add_augment(element: Element, augment: Augment):
	player_augments[element] = augment

# === SIGNAL HANDLERS ===
func _on_hitbox_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemy"):
		return
	
	# Determine which side the enemy was hit from
	var side = -1 if get_parent().global_position > body.global_position else 1
	get_active_element().enemy_hit(body, side)
