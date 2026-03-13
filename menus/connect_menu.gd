extends VBoxContainer


signal canceled


func _on_cancel_button_pressed() -> void:
	canceled.emit()
