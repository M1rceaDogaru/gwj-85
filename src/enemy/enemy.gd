extends Area2D

@export var move_speed: float = 100.0
@export var max_hp: int = 20
@export var damage: int = 10

var hp: int
var player: Node = null

signal died

func _ready() -> void:
	hp = max_hp

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		position += direction * move_speed * delta

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		died.emit()
		queue_free()

# Detect player collision
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.take_damage(damage)
