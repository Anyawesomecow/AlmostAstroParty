extends Control
@onready var startButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Start
@onready var joinButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Join
@onready var settingsButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/settings
@onready var hostButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/host


func _ready(): # Called when the node enters the scene tree for the first time. lets you use tab and enter in menue
	startButton.grab_focus()
	joinButton.hide()
	settingsButton.hide()
	hostButton.hide()
	$OptionsMenu.hide()

func _on_start_pressed():# starts game
	startButton.hide()
	joinButton.show()
	joinButton.grab_focus()
	settingsButton.show()
	hostButton.show()


func _input(event):
	if event.is_action_pressed("esc"):
		$OptionsMenu.hide()

func _on_join_pressed():
	Lobby.is_server = false
	get_tree().change_scene_to_file("res://levals/leval.tscn")
	
	

func _on_settings_pressed():
	$OptionsMenu.show()

func _on_host_pressed():
	Lobby.is_server = true
	get_tree().change_scene_to_file("res://levals/leval.tscn")
