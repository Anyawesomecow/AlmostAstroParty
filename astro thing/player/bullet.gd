extends Node2D

var velocity = Vector2()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	velocity += Vector2(150, 150)
	print(position)

