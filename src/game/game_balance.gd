extends Node

# Base values
@export var base_enemy_hp: float = 20.0
@export var base_spawn_rate: float = 1.0   # enemies per second
@export var base_enemy_count: int = 3
@export var base_enemy_speed: float = 60.0 # pixels per second
@export var base_weapon_damage: float = 10.0

# Growth factors
@export var enemy_hp_growth: float = 0.15   # 15% per minute
@export var spawn_rate_growth: float = 0.25 # 25% per minute
@export var enemy_count_growth: float = 0.20
@export var enemy_speed_growth: float = 0.05 # 5% faster per minute
@export var weapon_damage_growth: float = 0.5

# Example enemy type list (preload scenes + simple multipliers/weights)
var enemy_types = [
	{"name":"Bat",   "scene": preload("res://enemy/enemy.tscn"),   "hp_mul":1.0, "speed_mul":1.2, "weight":4, "start_minute":0},
	{"name":"Zombie","scene": preload("res://enemy/enemy.tscn"),"hp_mul":2.0, "speed_mul":0.7, "weight":3, "start_minute":1},
	{"name":"Ghoul", "scene": preload("res://enemy/enemy.tscn"), "hp_mul":3.0, "speed_mul":1.0, "weight":2, "start_minute":2},
	{"name":"Wraith","scene": preload("res://enemy/enemy.tscn"),"hp_mul":1.2, "speed_mul":1.4, "weight":2, "start_minute":3},
	{"name":"Brute", "scene": preload("res://enemy/enemy.tscn"), "hp_mul":5.0, "speed_mul":0.6, "weight":1, "start_minute":5}
]


# ------------------------
# Scaling functions
# ------------------------
func get_enemy_hp(minutes_passed: float) -> float:
	return base_enemy_hp * pow(1.0 + enemy_hp_growth, minutes_passed)

func get_enemy_speed(minutes_passed: float) -> float:
	return base_enemy_speed * pow(1.0 + enemy_speed_growth, minutes_passed)

func get_spawn_rate(minutes_passed: float) -> float:
	return base_spawn_rate * pow(1.0 + spawn_rate_growth, minutes_passed)

func get_enemy_count(minutes_passed: float) -> int:
	return int(base_enemy_count * pow(1.0 + enemy_count_growth, minutes_passed))

func get_weapon_damage(level: int) -> float:
	return base_weapon_damage * pow(1.0 + weapon_damage_growth, level)

func pick_enemy_type(minutes_passed: float) -> Dictionary:
	var types = enemy_types.filter(func(element): return element.start_minute <= minutes_passed)
	var total_weight = 0
	for t in types: total_weight += t["weight"]

	var roll = randi() % total_weight
	var accum = 0
	for t in types:
		accum += t["weight"]
		if roll < accum:
			return t
	return types[0] # fallback
