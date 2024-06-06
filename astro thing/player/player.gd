extends Node2D
var velocity = Vector2(0, 0)
var speed = 200
var angle = 0.0
var turnDirection = 1
var turnConstant = PI/45
@onready var sprite = $Sprite2D
#var turn = 0.0

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()

func _physics_process(delta):
	if Input.is_action_pressed("turn"):
		angle += turnConstant * turnDirection
		
	position += velocity * delta
	velocity.x = lerp(velocity.x, cos(angle) * speed, delta)
	velocity.y = lerp(velocity.y, sin(angle) * speed, delta)
