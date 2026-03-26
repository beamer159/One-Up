@tool
extends MarginContainer


const DAMAGE_DECREASE_DELAY := 1.0
const DAMAGE_DECREASE_RATE := 0.1

var tween: Tween


func _ready() -> void:
	%HealthBar.max_value = Globals.MAX_HEALTH
	%DamageBar.max_value = Globals.MAX_HEALTH
	set_health(Globals.MAX_HEALTH)


func take_damage(new_health: int) -> void:
	assert(new_health <= %HealthBar.value, "Damage cannot increase health")
	%HealthBar.value = new_health
	var damage = %DamageBar.value - %HealthBar.value
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_interval(DAMAGE_DECREASE_DELAY)
	tween.tween_property(%DamageBar, "value", %HealthBar.value, DAMAGE_DECREASE_RATE * damage)


func set_health(health: int) -> void:
	%HealthBar.value = health
	%DamageBar.value = health


func set_fill_mode(fill_mode: TextureProgressBar.FillMode) -> void:
	%DamageBar.fill_mode = fill_mode
	%HealthBar.fill_mode = fill_mode
