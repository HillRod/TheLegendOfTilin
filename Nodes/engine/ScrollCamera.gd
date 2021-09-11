extends Camera2D

var player_spawned: bool = false

func _process(delta):
	if player_spawned:
		var pos = get_tree().get_nodes_in_group("player")[0].global_position
		var x = (floor(pos.x / 1024)) * 1024
		var y = (floor(pos.y / 600)) * 600
		if global_position != Vector2(x,y):
			scrollAnimation(Vector2(x,y))

func scrollAnimation(newPos:Vector2):
	var tween = get_node("Tween")
	tween.interpolate_property(self, "global_position",
		global_position, newPos, 0.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
