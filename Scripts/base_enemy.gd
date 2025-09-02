extends CharacterBody2D

@onready var hp_label: Label = $HPLabel

@export var max_health : int = 3
var health := max_health
var speed := 100
var hitstunned : bool = false
enum state {Idle, Chase, Attack, Hitstunned}
var current_state : state
var player: CharacterBody2D
const CHASE_DISTANCE = 150
const ATTACK_DISTANCE = 20

func _ready() -> void:
	player = %Player
	update_hp()
	current_state = 0

func _process(delta: float) -> void:
	if current_state == 0:
		idle_state()
	elif current_state == 1:
		chase_state(delta)
	elif current_state == 2:
		attack_state()
	elif current_state == 3:
		hitstunned_state()
	

func idle_state():
	if global_position.x - player.global_position.x < CHASE_DISTANCE and global_position.x - player.global_position.x > -CHASE_DISTANCE:
		current_state = 1
func chase_state(delta):
	if global_position.x - player.global_position.x < 0:
		velocity.x = speed
	else: 
		velocity.x = -speed
	print(global_position.x - player.global_position.x)
	if global_position.x - player.global_position.x < ATTACK_DISTANCE and global_position.x - player.global_position.x > -ATTACK_DISTANCE:
		velocity.x = move_toward(velocity.x, 0, speed)
		current_state = 2
	elif global_position.x - player.global_position.x > CHASE_DISTANCE or global_position.x - player.global_position.x < -CHASE_DISTANCE:
		velocity.x = move_toward(velocity.x, 0, speed)
		current_state = 0

func attack_state():
	if global_position.x - player.global_position.x > ATTACK_DISTANCE or global_position.x - player.global_position.x < -ATTACK_DISTANCE:
		current_state = 1

func hitstunned_state():
	pass
	
func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta) -> void:
	if not is_on_floor() and hitstunned == false:
		velocity += get_gravity() * delta

func take_damage(damage, side):
	health -= damage
	update_hp()
	apply_knockback(side)
	if health <= 0:
		queue_free()

func update_hp():
	hp_label.text = (str(health) + "/" + str(max_health))

func apply_knockback(side):
	position.x = move_toward(position.x, position.x + 100, side * 10)
	position.y -= 5
	apply_hitstun()

func apply_hitstun():
	hitstunned = true
	current_state = 3
	await wait_frames(30)
	hitstunned = false
	current_state = 0
	
func wait_frames(frames: int) -> void:
	for i in range(frames):
		await get_tree().process_frame
