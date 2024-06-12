extends Node2D

@onready var bullet = preload("res://player/bullet.tscn")
@onready var Player = preload("res://player/player.tscn")
@onready var leval = $"."
@onready var player = $Player

func _ready():
	add_player()
	Events.shooting.connect(shoot)

	# TODO: handle local-multiplayer (or dont)
	# signal to server that we loaded
	Events.addingPlayer.connect(add_player)
	Lobby.player_loaded.rpc_id(1)
	Lobby.server_closed.connect(_on_server_closed)

func add_player():
	print("scrank")
	var playerReady = Player.instantiate()
	leval.add_child(playerReady)

func _on_server_closed():
	get_tree().change_scene_to_file("res://UI/Menus/Main Menue.gd")

func shoot():
	var BulletReady = bullet.instantiate()
	BulletReady.position = player.position + Vector2(cos(player.rotation) * 20, sin(player.rotation) * 20)
	BulletReady.rotation = player.rotation
	$bullet_holder.add_child(BulletReady)
