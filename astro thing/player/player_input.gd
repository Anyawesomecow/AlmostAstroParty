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
	if multiplayer.is_server():
		$"../amorecharge".start()
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)

func _process(delta):
	pass

func stop_boost():
	stop_boost_particals.rpc_id(1)

@rpc("call_local")
func stop_boost_particals():
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		player.stop_boost_visuals = true

func boostVisuals(): # change particals when boosting
	boost_particals.rpc_id(1)

@rpc("call_local")
func shoot():
	if player.amo > 0 and player.is_noodle == false and multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		var bullet_ready = player.bullet.instantiate()
		bullet_ready.position = player.position + Vector2(cos(player.rotation) * 20, sin(player.rotation) * 20)
		bullet_ready.rotation = player.rotation
		var bullet_holder = player.leval.get_node("bullet_holder")
		bullet_holder.add_child(bullet_ready, true)
		player.shootSound.play()
		$"../amorecharge".start()
		player.amo -= 1

@rpc("call_local")
func shipcolor():
	player.colors[0].hide()
	player.colors[1].hide()
	player.colors[2].hide()
	player.colors[3].hide()
	player.colors[player.color].show()





@rpc("call_local")
func boost_particals():
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() == player.player_id:
		player.do_boost_visuals = true


func dash(): #dash
	
	%PlayerInput.boostVisuals()
	server_rotation = server_rotation + turnConstant/4
	player.velocity = Vector2(150 * cos(server_rotation), 150 * sin(server_rotation))
	player.dashCooldown.start()


func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc_id(1)
	
	if Input.is_action_pressed("turn"):
		server_rotation += turnConstant * turnDirection * delta
	
	if not multiplayer.is_server() || Lobby.host_mode_enabled == true:
		pass


func _on_amorecharge_timeout():
	if player.amo >= 3: return
	player.amo += 1
