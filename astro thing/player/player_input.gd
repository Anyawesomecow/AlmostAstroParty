extends MultiplayerSynchronizer

var server_rotation




func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)

func _process(delta):
	pass
