extends Node2D


@onready var bullet = preload("res://player/bullet.tscn")
@onready var Player = preload("res://player/player.tscn")
@onready var breakableWall = preload("res://colidablals/brakeablewall.tscn")
@onready var leval = $"."

func _ready():
	var breakableWallReady = breakableWall.instantiate()
	
	$"wall spawner".add_child(breakableWallReady)
	
	if Lobby.is_server == true:
		Lobby.become_host()
	else:
		Lobby.Join_as_player()
	# TODO: handle local-multiplayer (or dont)
	# signal to server that we loaded
	#Lobby.player_loaded.rpc_id(1)
	#Lobby.server_closed.connect(_on_server_closed)


func _on_server_closed():
	get_tree().change_scene_to_file("res://UI/Menus/Main Menue.gd")
