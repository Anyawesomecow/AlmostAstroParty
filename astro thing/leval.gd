extends Node2D

@onready var bullet = preload("res://player/bullet.tscn")
@onready var leval = $"."
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.shooting.connect(shoot)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	var BulletReady = bullet.instantiate()
	BulletReady.position = player.position
	leval.add_child(BulletReady)
