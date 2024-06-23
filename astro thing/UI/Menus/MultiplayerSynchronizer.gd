extends MultiplayerSynchronizer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



@rpc("call_local")
func on_purp_pressed():
	
	Events.collor_to_instanciate = 0
	$"..".lables[0].text = ""
	$"..".lables[1].text = Events.username
	
	


@rpc("call_local")
func on_green_pressed():
	
	Events.collor_to_instanciate = 1
	
	$"..".lables[0].text = Events.username
	$"..".lables[1].text = ""
	Events.who_should_get_what_color = 2
