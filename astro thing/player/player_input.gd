extends MultiplayerSynchronizer

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(delta):
	pass
