@tool
class_name Game extends Resource


@abstract class RoundResult:
	var value: int
	
	func _init(p_value: int) -> void:
		value = p_value


class RoundWin extends RoundResult:
	var player_won: bool
	var is_one_up: bool
	var loser_old_health: int
	
	func _init(p_value: int, p_player_won: bool, p_is_one_up: bool, p_loser_old_health) -> void:
		super(p_value)
		player_won = p_player_won
		is_one_up = p_is_one_up
		loser_old_health = p_loser_old_health


class RoundTie extends RoundResult:
	func _init(p_value: int) -> void:
		super(p_value)


var min_attack := 1
var _player_health := Globals.MAX_HEALTH:
	set(value):
		_player_health = maxi(0, value)
@export_range(0, Globals.MAX_HEALTH) var player_health := Globals.MAX_HEALTH:
	get:
		return _player_health
	set(value):
		_player_health = value
		player_health_changed.emit(player_health)
var _opponent_health := Globals.MAX_HEALTH:
	set(value):
		_opponent_health = maxi(0, value)
@export_range(0, Globals.MAX_HEALTH) var opponent_health := Globals.MAX_HEALTH:
	get:
		return _opponent_health
	set(value):
		_opponent_health = value
		opponent_health_changed.emit(opponent_health)

signal player_health_changed(new_value: int)
signal opponent_health_changed(new_value: int)

func resolve_round(player_attack: int, opponent_attack: int) -> RoundResult:
	assert(not is_over(), "resolve_round called on an ended game")
	assert(player_attack >= min_attack and player_attack <= 12, "player_attack out of range")
	assert(opponent_attack >= min_attack and opponent_attack <= 12, "opponent_attack out of range")
	var result := _determine_result(player_attack, opponent_attack)
	if result is RoundWin:
		var damage = 2 * result.value - 1 if result.is_one_up else result.value
		if result.player_won:
			_opponent_health -= damage
		else:
			_player_health -= damage
		min_attack = 1
	elif result is RoundTie:
		min_attack = mini(10, result.value)
	return result


func _determine_result(player_attack: int, opponent_attack: int) -> RoundResult:
	if player_attack == opponent_attack:
		return RoundTie.new(player_attack)
	var is_player_attack_bigger := player_attack > opponent_attack
	var is_one_up := absi(player_attack - opponent_attack) == 1
	var player_won := is_player_attack_bigger == is_one_up
	var winning_attack: int
	var loser_health: int
	if player_won:
		winning_attack = player_attack
		loser_health = opponent_health
	else:
		winning_attack = opponent_attack
		loser_health = player_health
	return RoundWin.new(winning_attack, player_won, is_one_up, loser_health)


func is_over() -> bool:
	return player_health == 0 or opponent_health == 0
