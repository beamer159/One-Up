@tool
class_name Game extends Resource


@abstract class RoundResult:
	pass


class RoundTie extends RoundResult:
	var attack: int
	
	func _init(p_attack: int) -> void:
		attack = p_attack


class RoundWin extends RoundResult:
	var player_won: bool
	var new_health: int:
		set(value):
			new_health = maxi(0, value)
	
	func _init(p_player_won: bool, p_new_health: int) -> void:
		player_won = p_player_won
		new_health = p_new_health


class RoundOneUp extends RoundWin:
	var intermediate_health: int:
		set(value):
			intermediate_health = maxi(0, value)
	
	func _init(player_won: bool, new_health: int, p_intermediate_health: int) -> void:
		super(player_won, new_health)
		intermediate_health = p_intermediate_health


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
		if result.player_won:
			_opponent_health = result.new_health
		else:
			_player_health = result.new_health
		min_attack = 1
	elif result is RoundTie:
		min_attack = mini(10, result.attack)
	return result


func _determine_result(player_attack: int, opponent_attack: int) -> RoundResult:
	if player_attack == opponent_attack:
		return RoundTie.new(player_attack)
	var is_player_attack_bigger := player_attack > opponent_attack
	var is_one_up := absi(player_attack - opponent_attack) == 1
	var player_won := is_player_attack_bigger == is_one_up
	var winning_attack := player_attack if player_won else opponent_attack
	var starting_health := opponent_health if player_won else player_health
	# Health calculations below could be negative.
	# This should be resolved in the results' health setters.
	if is_one_up:
		var intermediate_health := starting_health - (winning_attack - 1)
		var new_health := intermediate_health - winning_attack
		return RoundOneUp.new(player_won, new_health, intermediate_health)
	else:
		var new_health := starting_health - winning_attack
		return RoundWin.new(player_won, new_health)


func is_over() -> bool:
	return player_health == 0 or opponent_health == 0
