extends VBoxContainer


func _ready() -> void:
	get_window().files_dropped.connect(_on_files_dropped)


func _on_files_dropped(files: PackedStringArray) -> void:
	DisplayServer.clipboard_set("\n".join(Array(files).map(
		func(path):
			return "%s\n```\n%s\n```" % [path.get_file(), FileAccess.get_file_as_string(path)])))
	var tween := create_tween()
	%Confirmation.modulate = Color.WHITE
	tween.tween_property(%Confirmation, "modulate", Color.TRANSPARENT, 1.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
