extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_gray_pressed():
	pass # Replace with function body.


func _on_blue_pressed():
	pass # Replace with function body.


func _on_red_pressed():
	pass # Replace with function body.


func _on_green_pressed():
	Events.collor_to_instanciate = 1
	get_tree().change_scene_to_file("res://levals/leval.tscn")


func _on_purp_pressed():
	Events.collor_to_instanciate = 0

	get_tree().change_scene_to_file("res://levals/leval.tscn")
