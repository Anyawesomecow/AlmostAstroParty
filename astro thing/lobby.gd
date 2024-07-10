# handles all of the boring lobby-related networking logic
extends Node

const PORT = 27015
const MAX_CONNECTIONS = 8
const MAIN_MENU_SCENE = "res://UI/Menus/Main Menue.tscn"
const PLAYER_SCENE = preload("res://player/player.tscn")

const COLORS = {
	purple = {

	},
	green = {

	},
	blue = {

	},
	red = {

	}
}
# other players player info
var clients = {
	
}

# local player info
var player_info = {"name": null, "color": "unassigned", "score": null} # RAJA MAKKE THIS WORK ILL GIVE YOU HEAD PLEAZZZZE

signal player_connected(id: int, info: Dictionary)
signal player_disconnected(id: int)
signal player_color_assigned(id: int, color: String)
signal server_closed()

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_closed)
	multiplayer.connected_to_server.connect(_on_connection_established)
	multiplayer.connection_failed.connect(_on_connection_disestablished)

func debug(str):
	if multiplayer.multiplayer_peer == null:
		return
	var id = multiplayer.get_unique_id()
	print("[peer {id}] {str}".format({"id": id, "str": str}))

func get_or_create_client(id: int):
	if clients.has(id):
		return clients[id]
	clients[id] = {}
	return clients[id]

func get_client(id: int):
	return clients.get(id)

func get_client_name(client_id: int) -> String:
	var client = get_client(client_id)
	if client == null || !client.has("info") || !client.info.has("name"):
		return "unknown"
	return client.info.name
	
func get_client_color(client_id: int) -> String:
	var client = get_client(client_id)
	if client == null || !client.has("info") || !client.info.has("color"):
		return "unassigned"
	return client.info.color

func get_available_colors():
	var available_colors = COLORS.keys()
	for client_id in clients:
		var client = get_client(client_id)
		if client.has("info") && client.info.has("color"):
			available_colors.erase(client.info.color)
	return available_colors

func can_start_game():
	if !multiplayer.is_server():
		return false
	if clients.size() < 2:
		return false
	return true

func kick_client(client_id: int):
	if !multiplayer.is_server():
		return
	var peer = multiplayer.multiplayer_peer
	peer.disconnect_peer(client_id)
	clients.erase(client_id)

func start_game():
	if !can_start_game(): return
	for client_id in clients:
		var client = get_client(client_id)
		if !client.has("info"):
			force_update_client.rpc(client_id, {"name": "weirdo", "color": "unassigned"})
		if client.info.color == "unassigned":
			var available_colors = get_available_colors()
			if available_colors.is_empty():
				push_warning("Out of colors, disconnecting client {name} ({id})".format({ "name": client.info.name, "id": client_id }))
				kick_client(client_id)
				continue
			client.info.color = available_colors.pick_random()
	change_scene.rpc("res://levals/leval.tscn")
	
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
	var client = get_or_create_client(1)
	client.info = player_info
	player_connected.emit(1, player_info)
	
func disconnect_peer():
	multiplayer.multiplayer_peer = null

func spawn_player(id: int):
	if !multiplayer.is_server(): return
	var client = get_client(id)
	if client == null: return
	var player_instance = PLAYER_SCENE.instantiate()
	player_instance.player_id = id
	player_instance.player_name = get_client_name(id)
	player_instance.color = client.info.color
	client.instance = player_instance
	var shipspawn_node = get_tree().get_current_scene().get_node("shipholder")
	shipspawn_node.add_child(player_instance, true)

@rpc("authority", "call_local", "reliable")
func change_scene(path: String):
	get_tree().change_scene_to_file(path)

@rpc("authority", "call_local", "reliable")
# forcefully updates a clients info table to be correct on all clients
func force_update_client(client_id: int, info):
	var client = get_client(client_id)
	if client == null: return
	client.info = info
	if client.info.has("color"):
		player_color_assigned.emit(client_id, client.info.get("color"))

@rpc("any_peer", "call_remote", "reliable")
func request_update_client():
	if !multiplayer.is_server():
		var target_client_id = multiplayer.get_remote_sender_id()
		for client_id in clients:
			var client = clients[client_id]
			force_update_client.rpc_id(target_client_id, client_id, client.info)

@rpc("any_peer", "call_local", "reliable")
func claim_color(color: String):
	if color != "unassigned" && !COLORS.has(color): return
	var client_id = multiplayer.get_remote_sender_id()
	var client = get_client(client_id)

	if client == null: return
	if color != "unassigned":
		for other_client_id in clients:
			var other_client = clients[other_client_id]
			if !other_client.has("info") || !other_client.info.has("color"):
				continue
			if other_client.info.color == color:
				return
	client.info.color = color
	player_color_assigned.emit(client_id, client.info.color)

# used to detect when players are finished loading into a new scene
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		# TODO: count loaded players and start game accordingly
		var client_id = multiplayer.get_unique_id()
		var client = get_or_create_client(client_id)

# called on every other player when a player connects
@rpc("any_peer", "reliable")
func _register_player(info):
	var client_id = multiplayer.get_remote_sender_id()
	var client = get_or_create_client(client_id)
	if !client.has("info"):
		client.info = {}
	client.info.name = info.name
	client.info.color = info.color # someone could probably exploit this to claim two colors
	if client.info.color == null:
		client.info.color = "unassigned"
	player_connected.emit(client_id, info)
	player_color_assigned.emit(client_id, client.info.color)

# when a new player connects:
# 	- called on the newly connecting players machine once for each other player (including server, id 1)
# 	- called once on existing players
func _on_player_connected(id: int):
	# update that player on our personal info
	_register_player.rpc_id(id, player_info)
	
# called on all other peers
func _on_player_disconnected(id: int):
	clients.erase(id)
	player_disconnected.emit(id)
	player_color_assigned.emit(id, null)

# client-side
func _on_server_closed():
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
	multiplayer.multiplayer_peer = null
	clients.clear()
	server_closed.emit()

# client-side, when connected to server
func _on_connection_established():
	var client_id = multiplayer.get_unique_id()
	var client = get_or_create_client(client_id)
	if !client.has("info"):
		client.info = {}
	client.info.name = player_info.name
	player_connected.emit(client_id, player_info)

# client-side, disconnect from server
func _on_connection_disestablished():
	multiplayer.multiplayer_peer = null

'
const Server_port = 8080
const Server_IP = "127.0.0.1"

var is_server

var host_mode_enabled = false

var player = preload("res://player/player.tscn")
var charecter_menue = preload("res://UI/Menus/charecterSelection.tscn")

var shipspawn_node

var is_ready_spawn = false

var players = {}

var player_color = {}

func become_host():
	
	
	host_mode_enabled = true
	
	
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(Server_port)
	
	multiplayer.multiplayer_peer = server_peer
	multiplayer.peer_connected.connect(add_player_to_game)
	multiplayer.peer_connected.connect(add_menue)
	
	multiplayer.peer_disconnected.connect(del_player)
	
	
	
	
	

func add_menue(id: int):
	if multiplayer.is_server():
		var chrecterspawnmenue = get_tree().get_current_scene().get_node("MultiplayerSpawner")
		var menue = charecter_menue.instantiate()
		menue.player_id = id
		print(id)
		chrecterspawnmenue.add_child(menue, true)
		


func game_starts():
	add_player_to_game(1)


func Join_as_player():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(Server_IP, Server_port)
	
	multiplayer.multiplayer_peer = client_peer
	


func add_player_to_game(id: int):
	if multiplayer.is_server():
		await Events.addingPlayers
		var player_to_add = player.instantiate()
		player_to_add.player_id = id
		player_to_add.player_name = str(id)
		player_to_add.color = Events.collor_to_instanciate
		player_color = id
		players[id] = player_to_add
		
		shipspawn_node = get_tree().get_current_scene().get_node("shipholder")
		shipspawn_node.add_child(player_to_add, true)
	

func del_player(id: int):
	if shipspawn_node == null:
		return
	if not shipspawn_node.has_node(str(id)):
		return
		
	shipspawn_node.get_node(str(id)).queue_free()


'
