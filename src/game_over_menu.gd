extends PanelContainer


signal rematch_selected
signal quit_selected


func _on_rematch_button_pressed() -> void:
	rematch_selected.emit()


func _on_quit_button_pressed() -> void:
	quit_selected.emit()
