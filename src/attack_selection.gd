@tool
extends VBoxContainer


const ATTACK_COUNT := 12

@onready var attack_buttons := %Attacks.get_children()

@export_range(1, ATTACK_COUNT - 2) var min_attack: int = 1:
	set(value):
		min_attack = clampi(value, 1, ATTACK_COUNT - 2)
		if not is_node_ready():
			return
		for i in ATTACK_COUNT:
			attack_buttons[i].disabled = i < min_attack - 1

signal attack_selected(attack: int)


func _ready() -> void:
	assert(attack_buttons.size() == ATTACK_COUNT, "Button count and attack count don't match")
	for i: int in %Attacks.get_child_count():
		var attack_button: Button = %Attacks.get_child(i)
		attack_button.custom_minimum_size.x = attack_button.size.y
		attack_button.pressed.connect(_on_attack_selected.bind(i + 1))
	min_attack = min_attack


func _on_attack_selected(attack: int) -> void:
	attack_selected.emit(attack)
