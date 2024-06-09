extends CharacterBody2D

var is_noodle = false
var angleBefore = 0
var speed = 200
var turnDirection = 1
var turnConstant = PI
var amo = 3
@onready var SIZE = Vector2(700, 400)
@onready var sprite = $Sprite2D
@onready var dashTimer = $dashTimer
@onready var dashCooldown = $dashCooldown


func _ready():
	$noodle.hide()
	$ship.show()


func getsHit():
	if is_noodle == true:
		queue_free()
	else:
		$denoodling.start()
		is_noodle = true

func dash():
	rotation = angleBefore + PI/2.5
	velocity = Vector2(150 * cos(rotation), 150 * sin(rotation))
	dashCooldown.start()

func _input(event):
	if event.is_action_pressed("shoot") and amo > 0:
		print("florp")
		Events.emit_signal("shooting")
		amo -= 1
	
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
func _physics_process(delta):
	
	if is_noodle == true:
		
		$ship.hide()
		$noodle.show()
	
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


func _on_amorecharge_timeout():
	if amo < 3:
		amo += 1


func _on_denoodling_timeout():
	$ship.show()
	$noodle.hide()
	is_noodle = false


func _on_area_2d_area_entered(area):
	getsHit()
