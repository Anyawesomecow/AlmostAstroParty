extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	var out = ""
	for client_id in Lobby.clients:
		var client = Lobby.get_client(client_id)
		var old_score = client.get("old_score", 0)
		var score = client.get("score", 0)
		out += "{name}: {old_score}->{score}\n".format({
			"name": client.info.name,
			"old_score": old_score,
			"score": score,
		})
		client.old_score = score
	$Label.text = out

func get_rand_leavel():
	var scheeenes = ["res://levals/breakbox_leaval.tscn", "res://levals/gravity_leaval.tscn"]
	var randnum = rng.randf_range(0,2)
	return scheeenes[randnum]
	


func _on_timer_timeout():
	if !multiplayer.is_server(): return
	Lobby.change_scene.rpc(get_rand_leavel())
