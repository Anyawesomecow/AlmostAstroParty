extends Control


@export var player_id := 1 :
	set(id):
		player_id = id

# @onready var lables = [$MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/greenbox/Label,
# $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/purpbox/Label]

@onready var labels = {
	purple = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/purpbox/Label,
	green = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/greenbox/Label,
	red = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/redbox/Label,
	blue = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/bluebox/Label,
}

@onready var buttons = {
	purple = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/purpbox/purp,
	green = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/greenbox/green,
	red = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/redbox/red,
	blue = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/bluebox/blue
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/PanelContainer/VBoxContainer/start.hide()
	Lobby.player_color_assigned.connect(_on_player_color_assigned)
	Lobby.request_update_client.rpc()
	if multiplayer.is_server():
		$MarginContainer/PanelContainer/VBoxContainer/start.show()
		Lobby.player_connected.connect(_on_player_connected)

func _on_player_color_assigned(id, _color):
	Lobby.debug("{id}->{color}".format({"id": id, "color": _color}))
	for label_id in labels:
		var label = labels[label_id]
		var button = buttons[label_id]
		label.text = ""
		button.disabled = false
	for client_id in Lobby.clients:
		var client = Lobby.clients[client_id]
		var color = client.info.get("color")
		if labels.has(color):
			labels[color].text = client.info.name 
			buttons[color].disabled = true

func _on_player_connected(id, _info):
	Lobby.change_scene.rpc_id(id, "res://UI/Menus/charecterSelection.tscn")

func _on_gray_pressed():
	Lobby.claim_color.rpc("unassigned")

func _on_blue_pressed():
	Lobby.claim_color.rpc("blue")

func _on_red_pressed():
	Lobby.claim_color.rpc("red")

func _on_green_pressed():
	Lobby.claim_color.rpc("green")

func _on_purp_pressed():
	Lobby.claim_color.rpc("purple")

func _on_start_pressed():
	Lobby.start_game()
	
