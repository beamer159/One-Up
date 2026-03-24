extends MarginContainer


enum HSide {
	LEFT,
	RIGHT
}

const DAMAGE_DECREASE_DELAY := 1.0
const DAMAGE_DECREASE_DURATION := 0.1

var tween: Tween

@export var side: HSide:
	set(value):
		side = value
		if not is_node_ready():
			return
		if side == HSide.LEFT:
			%DamageBar.fill_mode = TextureProgressBar.FillMode.FILL_RIGHT_TO_LEFT
			%HealthBar.fill_mode = TextureProgressBar.FillMode.FILL_RIGHT_TO_LEFT
		else:
			%DamageBar.fill_mode = TextureProgressBar.FillMode.FILL_LEFT_TO_RIGHT
			%HealthBar.fill_mode = TextureProgressBar.FillMode.FILL_LEFT_TO_RIGHT

var health := Globals.MAX_HEALTH:
	set(value):
		if value >= health:
			health = mini(Globals.MAX_HEALTH, value)
			%HealthBar.value = health
			%DamageBar.value = health
		else:
			health = maxi(0, value)
			%HealthBar.value = health
			var damage_to_remove: float = %DamageBar.value - health
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_interval(DAMAGE_DECREASE_DELAY)
			tween.tween_property(%DamageBar, "value", health, DAMAGE_DECREASE_DURATION * damage_to_remove)


func _ready() -> void:
	%HealthBar.max_value = Globals.MAX_HEALTH
	%HealthBar.value = Globals.MAX_HEALTH
	%DamageBar.max_value = Globals.MAX_HEALTH
	%DamageBar.value = Globals.MAX_HEALTH
	side = side


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		health -= int(event.as_text_keycode())
