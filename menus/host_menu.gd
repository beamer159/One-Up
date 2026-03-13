extends VBoxContainer


signal host_selected(port: int)
signal back_selected


func _on_host_button_pressed() -> void:
	host_selected.emit(int(%PortInput.text))


func _on_back_button_pressed() -> void:
	back_selected.emit()
