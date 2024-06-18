extends MultiplayerSynchronizer

var server_rotation = 0
var turnConstant = PI
var turnDirection = 1


@onready var boostship = $"../ship_blue"
@onready var shipParticals1 = $"../particals_ship/CPUParticles2D"
@onready var shipParticals2 = $"../particals_ship/CPUParticles2D2"
@onready var shipParticals3 = $"../particals_ship/CPUParticles2D3"
@onready var shipParticals4 = $"../particals_ship/CPUParticles2D4"
@onready var player = $".."


func _ready():
	server_rotation += turnConstant * turnDirection
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)

func _process(delta):
	pass

func stop_boost():
	stop_boost_particals.rpc()

@rpc("call_local")
func stop_boost_particals():
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		player.stop_boost_visuals = true

func boostVisuals(): # change particals when boosting
	boost_particals.rpc()

@rpc("call_local")
func shoot():
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		var bullet_ready = player.bullet.instantiate()
		bullet_ready.position = player.position + Vector2(cos(player.rotation) * 20, sin(player.rotation) * 20)
		bullet_ready.rotation = player.rotation
		var bullet_holder = player.leval.get_node("bullet_holder")
		bullet_holder.add_child(bullet_ready, true)
		player.shootSound.play()
		player.amo -= 1


@rpc("call_local")
func boost_particals():
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		player.do_boost_visuals = true


func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		if player.amo > 0 and player.is_noodle == false:
			shoot.rpc()
	
	
	
	if Input.is_action_pressed("turn"):
		server_rotation += turnConstant * turnDirection * delta
	
	if not multiplayer.is_server() || Lobby.host_mode_enabled == true:
		pass
