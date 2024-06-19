extends HSlider



var buss_index

# Called when the node enters the scene tree for the first time.
func _ready():
	buss_index = AudioServer.get_bus_index("music")
	value_changed.connect(set_main_volume)
	value = db_to_linear(AudioServer.get_bus_volume_db(buss_index))


func set_main_volume(value: float):
	AudioServer.set_bus_volume_db(
		buss_index,
		linear_to_db(value)
	)
