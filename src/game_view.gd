@tool
extends Node


@export var game: Game = Game.new()
var player_attack := 0
var opponent_attack := 0
var player_selection_tween: Tween


func _on_player_attack_received(p_player_attack: int) -> void:
	player_attack = p_player_attack
	player_selection_tween = create_tween()
	player_selection_tween.tween_property(%CenteredAttackSelection, "scale:x", 0, 0.25) \
		.set_delay(0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	%PlayerAttack.frame = player_attack
	player_selection_tween.tween_property(%PlayerAttack, "scale:x", 3, 0.25) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	player_selection_tween.tween_interval(0.4)
	player_selection_tween.tween_property(%PlayerAttack, "scale", Vector2(2, 2), 0.6) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	player_selection_tween.parallel().tween_property(%PlayerAttack, "position", Vector2(200, 180), 0.6) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	player_selection_tween.tween_interval(0.1)
	player_selection_tween.tween_property(%OpponentAttack, "position:x", 440, 0.6) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	if opponent_attack > 0:
		_resolve_round()


func _on_opponent_attack_received(p_opponent_attack: int) -> void:
	opponent_attack = p_opponent_attack
	if player_attack > 0:
		_resolve_round()


func _ready() -> void:
	# These are needed to initialize a modified exported value at startup.
	# This isn't a problem in the editor, but during runtime startup,
	# the game signals are emitted before they are connected below
	%Hud.player_life.set_health(game.player_health)
	%Hud.opponent_life.set_health(game.opponent_health)
	
	# Note: these signals are not emitted when damage is taken. They are
	# primarily used to reflect health changes due to modifying export values
	game.player_health_changed.connect(%Hud.player_life.set_health)
	game.opponent_health_changed.connect(%Hud.opponent_life.set_health)

func _resolve_round() -> void:
	var result := game.resolve_round(player_attack, opponent_attack)
	if result is Game.RoundOneUp:
		_resolve_round_one_up(result)
	elif result is Game.RoundWin:
		_resolve_round_win(result)
	elif result is Game.RoundTie:
		_resolve_round_tie(result)
	player_attack = 0
	opponent_attack = 0


func _resolve_round_one_up(result: Game.RoundOneUp) -> void:
	var life_display := _get_damaged_life_display(result.player_won)
	life_display.take_damage(result.intermediate_health)
	await get_tree().create_timer(0.5).timeout
	life_display.take_damage(result.new_health)


func _resolve_round_win(result: Game.RoundWin) -> void:
	var life_display := _get_damaged_life_display(result.player_won)
	life_display.take_damage(result.new_health)


func _resolve_round_tie(result: Game.RoundTie) -> void:
	pass


func _get_damaged_life_display(player_won: bool) -> LifeDisplay:
	return %Hud.opponent_life if player_won else %Hud.player_life


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var number := int(event.as_text_keycode())
		if number == 0:
			return
		_on_opponent_attack_received(number)
