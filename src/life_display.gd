@tool
class_name LifeDisplay extends VBoxContainer


enum HSide {
	LEFT,
	RIGHT
}

const FILL_MODE_MAP := {
	HSide.LEFT: TextureProgressBar.FillMode.FILL_RIGHT_TO_LEFT,
	HSide.RIGHT: TextureProgressBar.FillMode.FILL_LEFT_TO_RIGHT
}

@export var side: HSide:
	set(value):
		side = value
		if not is_node_ready():
			return
		%Healthbar.set_fill_mode(FILL_MODE_MAP[side])
		if side == HSide.LEFT:
			%NameAndHealth.move_child(%PlayerName, 0)
			%NameAndHealth.move_child(%HealthValue, -1)
		else:
			%NameAndHealth.move_child(%HealthValue, 0)
			%NameAndHealth.move_child(%PlayerName, -1)


@export var player_name: String:
	set(value):
		player_name = value
		if not is_node_ready():
			return
		%PlayerName.text = player_name


func _ready() -> void:
	side = side
	player_name = player_name


func set_health(health: int) -> void:
	health = clampi(health, 0, Globals.MAX_HEALTH)
	%HealthValue.text = str(health)
	%Healthbar.set_health(health)


func take_damage(new_health: int) -> void:
	new_health = maxi(0, new_health)
	%HealthValue.text = str(new_health)
	%Healthbar.take_damage(new_health)
