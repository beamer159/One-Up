extends MarginContainer


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)


func _on_main_menu_host_selected() -> void:
	_switch_menus(%MainMenu, %HostMenu)


func _on_main_menu_join_selected() -> void:
	_switch_menus(%MainMenu, %JoinMenu)


func _on_host_menu_host_selected(port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	_switch_menus(%HostMenu, %ConnectMenu)
	


func _on_host_menu_back_selected() -> void:
	_switch_menus(%HostMenu, %MainMenu)


func _on_join_menu_join_selected(ip: String, port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	_switch_menus(%JoinMenu, %ConnectMenu)


func _on_join_menu_back_selected() -> void:
	_switch_menus(%JoinMenu, %MainMenu)


func _on_connect_menu_canceled() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	_switch_menus(%ConnectMenu, %MainMenu)


func _switch_menus(menu_from: CanvasItem, menu_to: CanvasItem) -> void:
	menu_from.hide()
	menu_to.show()


func _on_peer_connected(id: int) -> void:
	print("Peer ", id, " connected!")
	get_tree().change_scene_to_file("res://game.tscn")
