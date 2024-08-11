extends Node2D


@onready var bullet = preload("res://player/bullet.tscn")
@onready var Player = preload("res://player/player.tscn")
@onready var breakableWall = preload("res://colidablals/brakeablewall.tscn")
@onready var leval = $"."

func _spawn_players():
	if !multiplayer.is_server(): return
	for client_id in Lobby.clients:
		Lobby.spawn_player(client_id)

func _ready():
	Events.addingPlayers.emit()
	_spawn_players.call_deferred()
