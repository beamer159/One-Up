@tool
extends Sprite2D


@export var power: int:
	set(value):
		power = value
		reveal()
const FLIP_SPEED := 0.2


func reveal():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.DOWN, FLIP_SPEED) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): frame = power)
	tween.tween_property(self, "scale", Vector2.ONE, FLIP_SPEED) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
