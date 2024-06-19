extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	create_action_list()


@onready var Input_button_scene = preload("res://UI/Menus/inputButton.tscn")
@onready var Action_list = $TabContainer/Controlls/MarginContainer/VBoxContainer/ScrollContainer/action_list
var is_remaping = false
var action_to_remap = null
var remapping_button = null
var opend = false
var actionsMap = {"turn" : "Turn",
"shoot" : "Shoot",
}

func create_action_list():
	InputMap.load_from_project_settings()
	for item in Action_list.get_children():
		item.queue_free()
		
	for action in actionsMap:
		var button = Input_button_scene.instantiate()
		var action_lable = button.find_child("action")
		var input_lable = button.find_child("input")
		action_lable.text = actionsMap[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_lable.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_lable.text = ""
		Action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remaping:
		is_remaping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("input").text = "Press key to rebind"
func open():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	opend = true
	
func close():
	hide()
	opend = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _input(event):
	if is_remaping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			
			
			is_remaping = false
			action_to_remap = null
			remapping_button = null
			accept_event()
	
	
	if event.is_action_pressed("esc"):
		if opend == false:
			pass
		else:
			close()
			

func _update_action_list(button, event):
	button.find_child("input").text = event.as_text().trim_suffix(" (Physical)")


func _on_rester_pressed():
	create_action_list()

