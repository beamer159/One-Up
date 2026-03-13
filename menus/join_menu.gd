extends VBoxContainer


signal join_selected(ip: String, port: int)
signal back_selected


func _on_join_button_pressed() -> void:
	join_selected.emit(%IpInput.text, int(%PortInput.text))


func _on_back_button_pressed() -> void:
	back_selected.emit()
