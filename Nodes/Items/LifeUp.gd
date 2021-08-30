extends Area2D
func _on_LifeUp_body_entered(body):
	if body.is_in_group("player"):
		print("+1")
		if body.vida<body.max_life:
			body.vida+=1
			body.lifebar.rect_size.x += 4.8
		queue_free()

func _ready():
	$AnimationPlayer.play("default")
	yield($AnimationPlayer,"animation_finished")
	
func _on_Timer_timeout():
	queue_free()
