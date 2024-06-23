extends Control
@onready var startButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Start
@onready var joinButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Join
@onready var settingsButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/settings
@onready var hostButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/host




func _ready(): # Called when the node enters the scene tree for the first time. lets you use tab and enter in menue
	if Events.username == null:
		$VBoxContainer.hide()
	else:
		$VBoxContainer.show()
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
	Lobby.Join_as_player()
	$VBoxContainer.hide()
	

func _on_settings_pressed():
	$OptionsMenu.show()

func _on_host_pressed():
	Lobby.become_host()
	$VBoxContainer.hide()
	


func _on_button_pressed():
	if $"name window/VBoxContainer/TextEdit".text != "":
		Events.username = $"name window/VBoxContainer/TextEdit".text
		$"name window".hide()
		$VBoxContainer.show()
