extends CharacterBody2D

var is_noodle = false
var angleBefore = 0
var speed = 200
var turnDirection = 1
var turnConstant = PI
var amo = 3
var defaultBurtAmount = 50
var defaultBurtAmountBurst = 100
@onready var shipParticals1 = $particals_ship/CPUParticles2D
@onready var shipParticals2 = $particals_ship/CPUParticles2D2
@onready var shipParticals3 = $particals_ship/CPUParticles2D3
@onready var shipParticals4 = $particals_ship/CPUParticles2D4
@onready var SIZE = Vector2(700, 400)
@onready var sprite = $Sprite2D
@onready var dashTimer = $dashTimer
@onready var dashCooldown = $dashCooldown


func _ready():
	$noodle.hide()
	$ship.show()
	shipParticals1.emitting = true
	shipParticals2.emitting = true
	shipParticals3.emitting = false
	shipParticals4.emitting = false
	shipParticals1.amount = defaultBurtAmount
	shipParticals2.amount = defaultBurtAmount
	shipParticals3.amount = defaultBurtAmountBurst
	shipParticals4.amount = defaultBurtAmountBurst

func getsHit():
	if is_noodle == true:
		queue_free()
	else:
		$denoodling.start()
		is_noodle = true

func dash():
	boostVisuals()
	rotation = angleBefore + PI/2.5
	velocity = Vector2(150 * cos(rotation), 150 * sin(rotation))
	dashCooldown.start()

func boostVisuals():
	shipParticals1.emitting = false
	shipParticals2.emitting = false
	shipParticals3.emitting = true
	shipParticals4.emitting = true

func _input(event):
	if event.is_action_pressed("shoot") and amo > 0 and is_noodle == false:
		print("florp")
		Events.emit_signal("shooting")
		amo -= 1
	
	if event.is_action_pressed("esc"):
		get_tree().quit()
		
func _physics_process(delta):
	
	
	
	if is_noodle == true:
		shipParticals1.emitting = false
		shipParticals2.emitting = false
		$ship.hide()
		$noodle.show()
	else:
		shipParticals1.emitting = true
		shipParticals2.emitting = true
	
	
	
	if Input.is_action_just_pressed("turn"):
		if dashTimer.time_left > 0 and dashCooldown.time_left == 0 and is_noodle == false:
			dash()
		else:
			angleBefore = rotation
			dashTimer.start()
	
	var collisionInfo = move_and_collide(velocity * delta)
	
	if Input.is_action_pressed("turn"):
		rotation += turnConstant * turnDirection * delta
	
	if collisionInfo:
		velocity = velocity.slide(collisionInfo.get_normal())
		
	if is_noodle == false:
			velocity = Vector2(lerp(velocity.x, cos(rotation) * speed, delta * .6), lerp(velocity.y, sin(rotation) * speed, delta * .6))
	else:
		if Input.is_action_pressed("shoot"):
			velocity = Vector2(lerp(velocity.x, cos(rotation) * speed, delta * .6), lerp(velocity.y, sin(rotation) * speed, delta * .6))
			
	if velocity.x > 0 or velocity.x < 0:
		velocity.x = lerp(velocity.x, float(0), delta * .8)
		
	if velocity.y > 0 or velocity.y < 0:
		velocity.y = lerp(velocity.y, float(0), delta * .8)
		
	position = Vector2(wrapf(position.x, 0, SIZE.x), wrapf(position.y, 0, SIZE.y))

func _on_amorecharge_timeout():
	if amo < 3:
		amo += 1


func _on_denoodling_timeout():
	$ship.show()
	$noodle.hide()
	
	is_noodle = false


func _on_area_2d_area_entered(area):
	getsHit()





func _on_dash_cooldown_timeout():
	shipParticals1.emitting = true
	shipParticals2.emitting = true
	shipParticals3.emitting = false
	shipParticals4.emitting = false
