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
	
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)

func _process(delta):
	pass

func stop_boost():
	stop_boost_particals.rpc()

@rpc("call_local")
func stop_boost_particals():
	if multiplayer.is_server():
		player.stop_boost_visuals = true

func boostVisuals(): # change particals when boosting
	boost_particals.rpc()

@rpc("call_local")
func boost_particals():
	if multiplayer.is_server():
		player.do_boost_visuals = true


func _physics_process(delta):
	
	
	
	
	
	if Input.is_action_pressed("turn"):
		server_rotation += turnConstant * turnDirection * delta
	
	if not multiplayer.is_server() || Lobby.host_mode_enabled == true:
		pass
