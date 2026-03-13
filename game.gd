extends VBoxContainer


var stored_attack := 0
@onready var player: Player = %PlayerView.player
@onready var opponent: Player = %OpponentView.player


func _ready() -> void:
	if OS.is_debug_build():
		var args := OS.get_cmdline_args()
		if args.has("server"):
			var peer = ENetMultiplayerPeer.new()
			peer.create_server(12345)
			multiplayer.multiplayer_peer = peer
		elif args.has("client"):
			var peer = ENetMultiplayerPeer.new()
			peer.create_client("127.0.0.1", 12345)
			multiplayer.multiplayer_peer = peer


func _on_attack_selection_attack_selected(power: int) -> void:
	%AttackSelection.hide()
	_receive_attack.rpc(power)
	if stored_attack > 0:
		_resolve_round(power, stored_attack)
	else:
		stored_attack = power


@rpc("any_peer")
func _receive_attack(power: int) -> void:
	if stored_attack > 0:
		_resolve_round(stored_attack, power)
	else:
		stored_attack = power


func _resolve_round(player_attack: int, opponent_attack: int) -> void:
	if player_attack == opponent_attack:
		return
	var player_attack_bigger := player_attack > opponent_attack
	var bigger_by_one := absi(player_attack - opponent_attack) == 1
	if player_attack_bigger == bigger_by_one:
		opponent.health -= player_attack
	else:
		player.health -= opponent_attack
	stored_attack = 0
	%AttackSelection.show()
