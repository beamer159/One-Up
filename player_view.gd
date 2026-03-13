extends VBoxContainer


@export var player: Player:
	set(value):
		player = value
		_set_player_name(player.name)
		_set_health(player.health)


func _ready() -> void:
	player.name_set.connect(_set_player_name)
	player.health_updated.connect(_set_health)


func _set_player_name(player_name: String) -> void:
	%PlayerName.text = player_name


func _set_health(health: int) -> void:
	%HealthValue.text = str(health)
