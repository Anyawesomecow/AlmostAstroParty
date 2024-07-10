extends Node2D

var SIZE = get_viewport_rect().size + Vector2(512, 512)
var velocity = Vector2()
var me = "res://player/bullet.tscn"
@export var id = -1
const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta):# screenwrap and move
	position = Vector2(wrapf(position.x, 0, SIZE.x), wrapf(position.y, 0, SIZE.y))
	position += velocity * delta
	velocity = Vector2(cos(rotation) * 20000 * delta, sin(rotation) * 20000 * delta)




func _on_area_2d_area_entered(wall): #deleats self when hit
	self.queue_free()


