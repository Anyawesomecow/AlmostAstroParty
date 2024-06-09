extends Node2D

var velocity = Vector2()
var me = "res://player/bullet.tscn"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _physics_process(delta):
	position += velocity * delta
	velocity = Vector2(cos(rotation) * 20000 * delta, sin(rotation) * 20000 * delta)




func _on_area_2d_area_entered(wall):
	self.queue_free()


