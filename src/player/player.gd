extends CharacterBody2D

@export var move_speed: float = 400.0
@export var max_hp: int = 100

var hp: int

signal died

func _ready() -> void:
	hp = max_hp

func _physics_process(delta: float) -> void:
	handle_movement(delta)

func handle_movement(delta: float) -> void:
	var horizontal_input = Input.get_axis("move_left", "move_right")
	var vertical_input = Input.get_axis("move_up", "move_down")
	velocity = Vector2(horizontal_input, vertical_input)

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * move_speed

	move_and_slide()

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		died.emit()
		queue_free()
