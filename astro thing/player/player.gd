extends CharacterBody2D

var color = 0

var is_noodle = false
var angleBefore = 0
var speed = 200
var turnDirection = 1
var turnConstant = PI
var amo = 3
var defaultBurtAmount = 50
var defaultBurtAmountBurst = 100
var do_boost_visuals = false
var stop_boost_visuals = false


@onready var colors = [$Purp, $Green, $Red, $Blue]
@onready var redship = colors[color].get_children()[0]
@onready var boostship = colors[color].get_children()[1]
@onready var noodle = colors[color].get_children()[2]
@onready var shipParticals1 = $particals_ship/CPUParticles2D
@onready var shipParticals2 = $particals_ship/CPUParticles2D2
@onready var shipParticals3 = $particals_ship/CPUParticles2D3
@onready var shipParticals4 = $particals_ship/CPUParticles2D4
@onready var SIZE = Vector2(512, 512)
@onready var noodleParticals = colors[color].get_children()[3].get_children()[0]
@onready var sprite = $Sprite2D
@onready var dashTimer = $dashTimer
@onready var dashCooldown = $dashCooldown
@onready var shootSound = $shootSound

@onready var input = $PlayerInput

var player_name


@export var player_id := 1 :
	set(id):
		player_id = id
		print(id)
		%PlayerInput.set_multiplayer_authority(id)

func _ready(): # onreadythings
	boostship.hide()
	noodle.hide()
	redship.show()
	redship.play()
	boostship.play()
	noodleParticals.emitting = false
	shipParticals1.emitting = true
	shipParticals2.emitting = true
	shipParticals3.emitting = false
	shipParticals4.emitting = false
	shipParticals1.amount = defaultBurtAmount
	shipParticals2.amount = defaultBurtAmount
	shipParticals3.amount = defaultBurtAmountBurst
	shipParticals4.amount = defaultBurtAmountBurst

	
	
func boostVisuals(): # change particals when boosting
	print("bwamp")
	noodle.hide()
	redship.hide()
	boostship.show()
	shipParticals1.emitting = false
	shipParticals2.emitting = false
	shipParticals3.emitting = true
	shipParticals4.emitting = true
	
	
func dash(): #dash
	%PlayerInput.boostVisuals()
	rotation = angleBefore + PI/2.5
	velocity = Vector2(150 * cos(rotation), 150 * sin(rotation))
	dashCooldown.start()

func _on_denoodling_timeout(): # un noodling

	$ship_red.show()
	$noodle.hide()


	shipParticals1.emitting = true
	shipParticals2.emitting = true
	noodleParticals.emitting = false

	is_noodle = false

func _on_area_2d_area_entered(area): # getting hit stuff
	if is_noodle == true:
		queue_free()
	else:
		$dashCooldown.stop()
		$denoodling.start()
		is_noodle = true
		boostship.hide()
		redship.show()
		shipParticals1.emitting = false
		shipParticals2.emitting = false
		shipParticals3.emitting = false
		shipParticals4.emitting = false
		noodleParticals.emitting = true
		redship.hide()
		noodle.show()


func _on_dash_cooldown_timeout_visuals():
	shipParticals1.emitting = true
	shipParticals2.emitting = true
	shipParticals3.emitting = false
	shipParticals4.emitting = false
	print("gump")
	boostship.hide()
	redship.show()

func _on_dash_cooldown_timeout(): # puts partcals back to normal after dash
	%PlayerInput.stop_boost()

func _on_amorecharge_timeout():# adds amo
	amo += 1

func _input(event):
	if amo < 3 and $amorecharge.time_left == 0:
		$amorecharge.start()
		
	
	if event.is_action_pressed("shoot") and amo > 0 and is_noodle == false:
		Events.emit_signal("shooting")
		shootSound.play()
		amo -= 1
	
	if event.is_action_pressed("esc"):
		# TODO: disconnecting, closing server
		get_tree().quit()
		
func _physics_process(delta):
	var collisionInfo = move_and_collide(velocity * delta)
	
	if do_boost_visuals == true:
		boostVisuals()
		do_boost_visuals = false
	
	if stop_boost_visuals == true:
		_on_dash_cooldown_timeout_visuals()
		stop_boost_visuals = false
	
	if Input.is_action_just_pressed("turn"):
		if dashTimer.time_left > 0 and dashCooldown.time_left == 0 and is_noodle == false:
			dash()
		else:
			angleBefore = rotation
			dashTimer.start()
	
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

