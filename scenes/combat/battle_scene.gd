extends Control

# Hero stats
var hero_hp = 100
var hero_stress = 0

# Enemy stats — set randomly at start
var enemy_hp = 100
var enemy_name = "Skeleton"
var enemy_min_damage = 8
var enemy_max_damage = 15
var enemy_min_stress = 5
var enemy_max_stress = 15

var hero_turn = true

@onready var hero_hp_label = $HeroHP
@onready var enemy_hp_label = $EnemyHP
@onready var status_label = $StatusLabel
@onready var restart_button = $RestartButton
@onready var attack_button = $AttackButton
@onready var stress_label = $StressLabel
@onready var enemy_name_label = $EnemyNameLabel

func _ready():
	attack_button.pressed.connect(_on_attack_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	restart_button.visible = false
	spawn_enemy()
	status_label.text = "Your turn! Press Attack."

func spawn_enemy():
	var roll = randi_range(1, 2)
	if roll == 1:
		enemy_name = "Skeleton"
		enemy_hp = 100
		enemy_min_damage = 8
		enemy_max_damage = 15
		enemy_min_stress = 5
		enemy_max_stress = 15
	else:
		enemy_name = "Cultist"
		enemy_hp = 70
		enemy_min_damage = 3
		enemy_max_damage = 8
		enemy_min_stress = 25
		enemy_max_stress = 40
	
	enemy_hp_label.text = "Enemy HP: " + str(enemy_hp)
	enemy_name_label.text = "Enemy: " + enemy_name
	print("Spawned enemy: " + enemy_name)

func apply_stress(amount: int):
	hero_stress += amount
	stress_label.text = "Stress: " + str(hero_stress)
	
	if hero_stress >= 200:
		hero_hp_label.text = "💀 Heart Attack!"
		status_label.text = "💀 Heart Attack! You LOSE!"
		attack_button.visible = false
		restart_button.visible = true
		return
	
	if hero_stress >= 100:
		status_label.text = "⚠️ Hero is AFFLICTED — Paranoid!"

func _on_attack_pressed():
	if not hero_turn:
		return
	
	# Hero attacks
	var hero_damage = randi_range(10, 20)
	enemy_hp -= hero_damage
	enemy_hp = max(enemy_hp, 0)
	enemy_hp_label.text = "Enemy HP: " + str(enemy_hp)
	status_label.text = "You dealt " + str(hero_damage) + " damage!"
	
	if enemy_hp <= 0:
		enemy_hp_label.text = enemy_name + " is DEAD!"
		status_label.text = "🏆 You WIN!"
		attack_button.visible = false
		restart_button.visible = true
		return
	
	# Enemy turn
	hero_turn = false
	attack_button.disabled = true
	status_label.text = enemy_name + " is attacking..."
	await get_tree().create_timer(1.0).timeout
	
	var enemy_damage = randi_range(enemy_min_damage, enemy_max_damage)
	var stress_damage = randi_range(enemy_min_stress, enemy_max_stress)
	
	hero_hp -= enemy_damage
	hero_hp = max(hero_hp, 0)
	hero_hp_label.text = "Hero HP: " + str(hero_hp)
	
	apply_stress(stress_damage)
	status_label.text = enemy_name + " dealt " + str(enemy_damage) + " dmg and " + str(stress_damage) + " stress!"
	
	if hero_hp <= 0:
		hero_hp_label.text = "Hero is DEAD!"
		status_label.text = "💀 You LOSE!"
		attack_button.visible = false
		restart_button.visible = true
		return
	
	hero_turn = true
	attack_button.disabled = false

func _on_restart_pressed():
	hero_hp = 100
	hero_stress = 0
	hero_turn = true
	hero_hp_label.text = "Hero HP: 100"
	stress_label.text = "Stress: 0"
	status_label.text = "Your turn! Press Attack."
	attack_button.visible = true
	attack_button.disabled = false
	restart_button.visible = false
	spawn_enemy()
