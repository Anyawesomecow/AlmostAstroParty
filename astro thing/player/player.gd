extends Node2D
var velocity = Vector2(0, 0)
var angle = 0

func turn():
	pass
	
func _physics_process(delta):
	
	velocity = Vector2(9, 9)
	position += velocity * delta
