extends GridContainer


signal attack_selected(power: int)


func _on_attack_selected(power: int) -> void:
	attack_selected.emit(power)
