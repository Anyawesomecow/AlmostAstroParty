extends Node2D
var velocity = Vector2(0, 0)
var speed = 200
var turnDirection = 1
var turnConstant = PI
@onready var SIZE = get_viewport_rect().size
@onready var sprite = $Sprite2D
#var turn = 0.0
func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
func _physics_process(delta):
	if Input.is_action_pressed("turn"):
		rotation += turnConstant * turnDirection * delta
		
	position += velocity * delta
	position = Vector2(wrapf(position.x, 0, SIZE.x), wrapf(position.y, 0, SIZE.y))
	velocity = Vector2(lerp(velocity.x, cos(rotation) * speed, delta * .6), lerp(velocity.y, sin(rotation) * speed, delta * .6))
