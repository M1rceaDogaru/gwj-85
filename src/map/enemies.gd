extends Node2D

@export var spawn_area: Node2D # where enemies spawn
var time_passed: float = 0.0
var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	var minutes = time_passed / 60.0

	var rate = GameBalance.get_spawn_rate(minutes)
	spawn_timer += delta

	while spawn_timer >= 1.0 / rate:
		spawn_timer -= 1.0 / rate
		spawn_enemies(minutes)

func spawn_enemies(minutes: float) -> void:
	var count = GameBalance.get_enemy_count(minutes)
	for i in count:
		var enemy_type = GameBalance.pick_enemy_type(minutes)
		var enemy = enemy_type["scene"].instantiate()

		# Scale stats
		enemy.hp = GameBalance.get_enemy_hp(minutes) * enemy_type["hp_mul"]
		enemy.move_speed = GameBalance.get_enemy_speed(minutes) * enemy_type["speed_mul"]
		enemy.player = spawn_area

		enemy.global_position = spawn_area.global_position + Vector2(randf_range(-200,200), randf_range(-200,200))
		get_tree().current_scene.add_child(enemy)
