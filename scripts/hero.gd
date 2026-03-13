extends Resource

@export var hero_name: String = "Hero"
@export var max_hp: int = 100
@export var current_hp: int = 100
@export var attack: int = 15
@export var speed: int = 5

func take_damage(amount: int):
	current_hp -= amount
	current_hp = max(current_hp, 0)
	print(hero_name + " took " + str(amount) + " damage! HP: " + str(current_hp))

func is_dead() -> bool:
	return current_hp <= 0
