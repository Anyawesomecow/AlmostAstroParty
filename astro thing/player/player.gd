extends CharacterBody2D

var angleBefore = 0
var speed = 200
var turnDirection = 1
var turnConstant = PI
@onready var SIZE = get_viewport_rect().size + Vector2(100, 100)
@onready var sprite = $Sprite2D
@onready var dashTimer = $dashTimer
@onready var dashCooldown = $dashCooldown

signal shooting

func dash():
	rotation = angleBefore + PI/2.5
	velocity = Vector2(150 * cos(rotation), 150 * sin(rotation))
	dashCooldown.start()

func _input(event):
	if event.is_action_pressed("shoot"):
		print("florp")
		emit_signal("shooting")
	
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
func _physics_process(delta):
	
	if Input.is_action_just_pressed("turn"):
		if dashTimer.time_left > 0 and dashCooldown.time_left == 0:
			dash()
		else:
			angleBefore = rotation
			dashTimer.start()
	
	var collisionInfo = move_and_collide(velocity * delta)
	
	if Input.is_action_pressed("turn"):
		rotation += turnConstant * turnDirection * delta
	
	if collisionInfo:
		velocity = velocity.slide(collisionInfo.get_normal())
		
	position = Vector2(wrapf(position.x, 0, SIZE.x), wrapf(position.y, 0, SIZE.y))
	velocity = Vector2(lerp(velocity.x, cos(rotation) * speed, delta * .6), lerp(velocity.y, sin(rotation) * speed, delta * .6))
