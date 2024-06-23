extends Control


@export var player_id := 1 :
	set(id):
		player_id = id

@onready var lables = [$MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/greenbox/Label,
$MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/purpbox/Label]

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/PanelContainer/VBoxContainer/start.hide()
	if multiplayer.is_server():
		$MarginContainer/PanelContainer/VBoxContainer/start.show()



func _on_gray_pressed():
	pass # Replace with function body.


func _on_blue_pressed():
	pass # Replace with function body.


func _on_red_pressed():
	pass # Replace with function body.



func _on_green_pressed():
	
	%MultiplayerSynchronizer.on_green_pressed.rpc()
	


func _on_purp_pressed():
	%MultiplayerSynchronizer.on_purp_pressed.rpc()




@rpc("call_local")
func start_game():
	get_tree().change_scene_to_file("res://levals/leval.tscn")
	Lobby.game_starts()


func _on_start_pressed():
	start_game.rpc()
	
