@tool
extends Sprite2D


const FLIP_SPEED := 0.2

var _tween: Tween

signal revealed


func flip_to(power: int) -> void:
	if _tween:
		_tween.kill()
	_tween = _create_flip_tween(power)


func conceil() -> void:
	if _tween:
		_tween.kill()
	_tween = _create_conceil_tween()


func reveal(power: int) -> void:
	frame = power
	if _tween:
		_tween.kill()
	_tween = _create_reveal_tween()


func _create_flip_tween(power: int) -> Tween:
	var tween := create_tween()
	tween.tween_subtween(_create_conceil_tween())
	tween.tween_callback(func(): frame = power)
	tween.tween_subtween(_create_reveal_tween())
	return tween


func _create_conceil_tween() -> Tween:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(0, 1), FLIP_SPEED) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	return tween


func _create_reveal_tween() -> Tween:
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, FLIP_SPEED) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): revealed.emit())
	return tween
