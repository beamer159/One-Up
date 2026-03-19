extends HBoxContainer


signal host_selected
signal join_selected


func _on_host_button_pressed() -> void:
	host_selected.emit()


func _on_join_button_pressed() -> void:
	join_selected.emit()
