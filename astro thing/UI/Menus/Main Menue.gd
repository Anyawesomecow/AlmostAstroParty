extends Control
@onready var startButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Start
@onready var joinButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Join
@onready var settingsButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/settings
@onready var hostButton = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/host

# Called when the node enters the scene tree for the first time.
func _ready():
	startButton.grab_focus()
	joinButton.hide()
	settingsButton.hide()
	hostButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# starts game
func _on_start_pressed():
	startButton.hide()
	joinButton.show()
	joinButton.grab_focus()
	settingsButton.show()
	hostButton.show()


func _on_join_pressed():
	get_tree().change_scene_to_file("res://levals/leval.tscn")


func _on_settings_pressed():
	pass # Replace with function body.


func _on_host_pressed():
	pass # Replace with function body.
