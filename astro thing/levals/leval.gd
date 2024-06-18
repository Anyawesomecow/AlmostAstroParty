extends Node2D

@onready var bullet = preload("res://player/bullet.tscn")
@onready var Player = preload("res://player/player.tscn")
@onready var leval = $"."

func _ready():
	pass
	# TODO: handle local-multiplayer (or dont)
	# signal to server that we loaded
	#Lobby.player_loaded.rpc_id(1)
	#Lobby.server_closed.connect(_on_server_closed)


func _on_server_closed():
	get_tree().change_scene_to_file("res://UI/Menus/Main Menue.gd")




func _on_button_pressed():
	Lobby.become_host()
	$Button.hide()
	$Button2.hide()


func _on_button_2_pressed():
	Lobby.Join_as_player()
	$Button2.hide()
	$Button.hide()
