extends Control
@onready var startButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Start
@onready var ip = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ip
@onready var joinButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Join
@onready var settingsButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/settings
@onready var hostButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/host

const CHARACTER_SELECT_SCENE = "res://UI/Menus/charecterSelection.tscn"
const CONFIG_PATH = "user://user.cfg"

var config = ConfigFile.new()

func _ready(): # Called when the node enters the scene tree for the first time. lets you use tab and enter in menue
	if Events.username == null:
		$"name window".show()
		$VBoxContainer.hide()
	else:
		$"name window".hide()
		$VBoxContainer.show()
	startButton.grab_focus()
	ip.hide()
	joinButton.hide()
	settingsButton.hide()
	hostButton.hide()
	$OptionsMenu.hide()
	config.load(CONFIG_PATH)
	$"name window/VBoxContainer/TextEdit".text = config.get_value("user", "username", "")

func _on_start_pressed():# starts game
	startButton.hide()
	joinButton.show()
	ip.show()
	joinButton.grab_focus()
	settingsButton.show()
	hostButton.show()


func _input(event):
	if event.is_action_pressed("esc"):
		$OptionsMenu.hide()

func _on_join_pressed():
	Lobby.join_game(ip.text)
	# $VBoxContainer.hide()

func _on_settings_pressed():
	$OptionsMenu.show()

func _on_host_pressed():
	Lobby.create_game()
	get_tree().change_scene_to_file(CHARACTER_SELECT_SCENE)
	# $VBoxContainer.hide()


func _on_button_pressed():
	if $"name window/VBoxContainer/TextEdit".text != "":
		Events.username = $"name window/VBoxContainer/TextEdit".text
		Lobby.player_info.name = Events.username
		$"name window".hide()
		$VBoxContainer.show()
		config.set_value("user", "username", Events.username)
		config.save(CONFIG_PATH)
