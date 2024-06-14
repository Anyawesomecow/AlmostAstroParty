# handles both client-side and server-side networking
# technically, the lobby host has both a server peer and a client peer
extends Node

'const PORT = 27015
const MAX_CONNECTIONS = 8

# other players player info
var players = {}

# local player info
var player_info = {"name": "Name"}

var _players_loaded = 0 # dont actually use this, this is a testing var

signal player_connected(id, info)
signal player_disconnected(id)
signal server_closed()

func _ready():
	# serevr-side
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_closed)
	
	# client-side
	multiplayer.connected_to_server.connect(_on_connection_established)
	multiplayer.connection_failed.connect(_on_connection_disestablished)
	
func join_game(addr = ""):
	if addr.is_empty(): addr = "localhost"
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(addr, PORT)
	if error: return error
	multiplayer.multiplayer_peer = peer

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error: return error
	multiplayer.multiplayer_peer = peer

	# pid 1 is server host by default
	players[1] = player_info
	player_connected.emit(1, player_info)
	
func remove_peer():
	multiplayer.multiplayer_peer = null

func change_scene(path):
	_change_scene.rpc(path)

@rpc("call_local", "reliable")
func _change_scene(path):
	get_tree().change_scene_to_file(path)

# used to detect when players are finished loading into a new scene
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		# TODO: count loaded players and start game accordingly
		_players_loaded += 1
		if _players_loaded == 2:
			print("Hello")

@rpc("any_peer", "reliable")
func _register_player(info):
	var id = multiplayer.get_remote_sender_id()
	players[id] = info
	player_connected.emit(id, info)

# server-side
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	
# server-side
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

# server-side
func _on_server_closed():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_closed.emit()

# client-side, when connected to server
func _on_connection_established():
	var id = multiplayer.get_unique_id()
	players[id] = player_info
	player_connected.emit(id, player_info)

# client-side, disconnect from server
func _on_connection_disestablished():
	multiplayer.multiplayer_peer = null'
	













const Server_port = 8080
const Server_IP = "127.0.0.1"

var player = preload("res://player/player.tscn")

var shipspawn_node

func become_host():
	
	shipspawn_node = get_tree().get_current_scene().get_node("shipholder")
	print(shipspawn_node)
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(Server_port)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(add_player_to_game)
	multiplayer.peer_disconnected.connect(del_player)
	
	add_player_to_game(1)


func Join_as_player():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(Server_IP, Server_port)
	
	multiplayer.multiplayer_peer = client_peer
	


func add_player_to_game(id: int):
	var player_to_add = player.instantiate()
	player_to_add.player_id = id
	player_to_add.player_name = str(id)
	
	shipspawn_node.add_child(player_to_add, true)

func del_player(id: int):
	if not shipspawn_node.has_node(str(id)):
		return
		
	shipspawn_node.get_node(str(id)).queue_free()


